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

@interface GameViewController () {
	ShaderBase* _shader;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
	
	GLKVector4 _vTrance;
	
	VArrayBase *_vArray;
	GLuint _textureId;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

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
    [_effect release];
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
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	{
		NSLog(@"%s", __PRETTY_FUNCTION__);
		[self checkHeightOfScreen];
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
    
    self.effect = [[[GLKBaseEffect alloc] init] autorelease];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    
    glEnable(GL_DEPTH_TEST);
	
	_vArray = [[SimpleTextureBuffer alloc] init];
    [_vArray loadResourceWithName:nil];

	{
		for (int i = 0; i < 4; i++) {
			_vTrance.v[i] = 0.0f;
		}
		_vTrance.y = 0.0f;
	}
	{
		_textureId = 0;
		NSString* filePath = [[NSBundle mainBundle] pathForResource:@"BG001" ofType:@"png"];
		{
			GLKTextureInfo *texInfo0 = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:nil];
			if (texInfo0 != nil) {
				NSLog(@"Texture loaded successfully. name = %d size = (%d x %d)",
					  
					  texInfo0.name, texInfo0.width, texInfo0.height);
				
				_textureId = texInfo0.name;
			}
		}
		
	}
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
	if (_vArray != nil) {
		[_vArray release];
	}
    
    self.effect = nil;
    
    if (_shader != nil) {
		[_shader release];
		_shader = nil;
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
	// 必須では無い？
    //[self.effect prepareToDraw];
    
	assert(_shader != nil);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	// 頂点バッファを選択
	glBindVertexArrayOES(_vArray.vertexArray);
    
	// シェーダープログラムを適用
    glUseProgram(_shader.programId);
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, _textureId);
    // シェーダーのユニフォーム変数をセット
	glUniform4fv([_shader getUniformIndex:UNI_SIMPLE_TEXTURE_TRANS],
				 1, &_vTrance.x);
    
    //glDrawArrays(GL_TRIANGLES, 0, _vArray.count);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, _vArray.count);
}


@end
