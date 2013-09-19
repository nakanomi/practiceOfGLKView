//
//  ViewController.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/15.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import "GameViewController.h"
#import "ShaderBase.h"
//#import "TestShader.h"
//#import "TestVArray.h"
//#import "SimpleTriangleShader.h"
//#import "SimpleTriangleBuffer.h"

#import "SimpleTextureShader.h"
#import "SimpleTextureBuffer.h"

#import "TextureBase.h"

#define _LOOP_NUM	800

@interface GameViewController () {
	ShaderBase* _shader;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
	// ユニフォーム変数として設定する位置情報。独立させていないと正常に表示されない？
	GLKVector4 _vTrance[_LOOP_NUM];
	
	VArrayBase *_vArray;
//	GLuint _textureId;
	TextureBase *_texture;
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;
- (void)checkHeightOfScreen;

@end

@implementation GameViewController

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [_context release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2] autorelease];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
	{
		NSLog(@"%s", __PRETTY_FUNCTION__);
		// OS6.0の場合、この段階だと正しい値を得られないようだ（3.5インチデバイスでも4インチの値になる）。
		[self checkHeightOfScreen];
		NSLog(@"%d", self.preferredFramesPerSecond);
		// 60FPSにする
		self.preferredFramesPerSecond = 60;
	}
	// [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	{
		NSLog(@"%s", __PRETTY_FUNCTION__);
		[self checkHeightOfScreen];
		CGSize screenSize;
		float scale = [[UIScreen mainScreen]scale];
		screenSize.width = self.view.frame.size.width * scale;
		screenSize.height = self.view.frame.size.height * scale;
		[VArrayBase setScreenSize:screenSize];
	}
    [self setupGL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (void)checkHeightOfScreen
{
	{
		NSLog(@"view height = %f", self.view.frame.size.height);
		float scale = [[UIScreen mainScreen]scale];
		float height = self.view.frame.size.height * scale;
		NSLog(@"dot = %f", height);
	}
}


- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
	_shader = [[SimpleTextureShader alloc] init];
	[_shader loadShaderWithVsh:@"ShaderSimpleTexture" withFsh:@"ShaderSimpleTexture"];
    
    glEnable(GL_DEPTH_TEST);
	
	_vArray = [[SimpleTextureBuffer alloc] init];
    [_vArray loadResourceWithName:nil];

	{
		for (int index = 0; index < _LOOP_NUM; index++) {
			for (int i = 0; i < 4; i++) {
				_vTrance[index].v[i] = 0.0f;
			}
			_vTrance[index].y = 0.0f;
		}
	}
	{
		_texture = [[TextureBase alloc] init];
		BOOL loadResult = [_texture loadTextureFromName:@"BG001"ofType:@"png"];
		assert(loadResult);
		
	}
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
	if (_vArray != nil) {
		[_vArray release];
	}
    
    if (_shader != nil) {
		[_shader release];
		_shader = nil;
    }
	if (_texture != nil) {
		[_texture release];
		_texture = nil;
	}
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	{
		static BOOL bLogRect = NO;
		if (!bLogRect) {
			bLogRect = YES;
			NSLog(@"width = %f, height = %f", rect.size.width, rect.size.height);
		}
	}
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Render the object with GLKit
    
	assert(_shader != nil);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	// 頂点バッファを選択
	glBindVertexArrayOES(_vArray.vertexArray);
	// テクスチャの補間をしない
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
	// シェーダープログラムを適用
    glUseProgram(_shader.programId);
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, _texture.textureId);
	
	_vTrance[0].x = -1.0f;
	for (int i = 1; i < _LOOP_NUM; i++) {
		_vTrance[i].x = _vTrance[i - 1].x + (2.0f / (float)_LOOP_NUM);
	}

	for (int i = 0; i < _LOOP_NUM; i++) {
		// シェーダーのユニフォーム変数をセット
		glUniform4fv([_shader getUniformIndex:UNI_SIMPLE_TEXTURE_TRANS],
					 1, &_vTrance[i].x);
		
		//glDrawArrays(GL_TRIANGLES, 0, _vArray.count);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, _vArray.count);
	}
}


@end
