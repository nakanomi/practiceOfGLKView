//
//  GameViewController2.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/19/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "GameViewController.h"
#import "ShaderBase.h"
//#import "TestShader.h"
//#import "TestVArray.h"
//#import "SimpleTriangleShader.h"
//#import "SimpleTriangleBuffer.h"

#import "SimpleTextureShader.h"
#import "SimpleTextureVBuffer.h"

//#import "FboTextureBuffer.h"
#import "SimpleFboShader.h"

#import "TextureBase.h"
#import "FboBase.h"

#define _LOOP_NUM	8

#define _USE_CONTROLER_FBO	0

@interface GameViewController ()
{
	ShaderBase* _shader;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
	// ユニフォーム変数として設定する位置情報。独立させていないと正常に表示されない？
	GLKVector4 _vTrance[_LOOP_NUM];
	
	VArrayBase *_vArray;
	//	GLuint _textureId;
	TextureBase *_texture;
	
    CADisplayLink *_displayLink;
	BOOL _animating;
	int _animationFrameInterval;
	
	// FBO
	FboBase *_fboBase;
	 
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;
- (void)checkHeightOfScreen;

- (void)startAnimation;
- (void)endAnimation;
- (void)drawFrame;
- (void)changeRenderTargetToFBO;
- (void)renderObjects;

- (void)setupFBO;
@end

@implementation GameViewController

- (void)dealloc
{
	[self endAnimation];
    [self tearDownGL];
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [_context release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
	view.delegate = self;
    
	{
		NSLog(@"%s", __PRETTY_FUNCTION__);
		// OS6.0の場合、この段階だと正しい値を得られないようだ（3.5インチデバイスでも4インチの値になる）。
		[self checkHeightOfScreen];
		/*
		NSLog(@"%d", self.preferredFramesPerSecond);
		// 60FPSにする
		self.preferredFramesPerSecond = 60;
		 */
	}
	// [self.navigationController setNavigationBarHidden:YES];
	_displayLink = nil;
	_animating = NO;
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
	[self startAnimation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
	
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
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

	[self setupFBO];
    
	_shader = [[SimpleTextureShader alloc] init];
	[_shader loadShaderWithVsh:@"ShaderSimpleTexture" withFsh:@"ShaderSimpleTexture"];
    
    glEnable(GL_DEPTH_TEST);
	
	_vArray = [[SimpleTextureVBuffer alloc] init];
	{
		CGSize sizeTexture = CGSizeMake(16.0f, 16.0f);
		CGSize sizeRenderBuffer = _fboBase.sizeFbo;
		SimpleTextureVBuffer *simpleVArray = (SimpleTextureVBuffer*)_vArray;
		[simpleVArray setupVerticesByTexSize:sizeTexture withRenderBufferSize:sizeRenderBuffer];
	}

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
		BOOL loadResult = [_texture loadTextureFromName:@"BG001" ofType:@"png"];
		assert(loadResult);
		
	}
	{
		GLKView *view = (GLKView*)(self.view);
		BOOL en = view.enableSetNeedsDisplay;
		NSLog(@"%d", en);
		en = view.enableSetNeedsDisplay;
		NSLog(@"%d", en);
	}
}

- (void)setupFBO
{
	_fboBase = [[FboBase alloc] init];
	CGSize size = CGSizeMake(512.0f, 512.0f);
	[_fboBase setupFboWithSize:size];
}


- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
	[_fboBase release];
    
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
#pragma mark -DisplayLink
- (void)startAnimation
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	if (!_animating) {
        CADisplayLink *aDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame)];
        [aDisplayLink setFrameInterval:_animationFrameInterval];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		_displayLink = aDisplayLink;
		_animating =YES;
	}
}
- (void)endAnimation
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	if (_animating) {
		[_displayLink invalidate];
		_displayLink = nil;
		_animating = NO;
	}
}
- (void)drawFrame
{
	GLKView *view = (GLKView*)(self.view);
	[view display];
}

- (void)changeRenderTargetToFBO
{
	[_fboBase changeRenderTargetToFBO];
	
}

- (void)renderObjects
{
    // Render the object with GLKit
    
	assert(_shader != nil);
	
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
		_vTrance[i].y = _vTrance[i - 1].y + (1.0f / (float)_LOOP_NUM);
	}
	
	for (int i = 0; i < _LOOP_NUM; i++) {
		// シェーダーのユニフォーム変数をセット
		glUniform4fv([_shader getUniformIndex:UNI_SIMPLE_TEXTURE_TRANS],
					 1, &_vTrance[i].x);
		
		//glDrawArrays(GL_TRIANGLES, 0, _vArray.count);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, _vArray.count);
	}
	
	//render objects
}


#pragma mark -GLKView delegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	{
		static BOOL bLogRect = NO;
		if (!bLogRect) {
			bLogRect = YES;
			NSLog(@"width = %f, height = %f", rect.size.width, rect.size.height);
		}
	}
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	BOOL bUseFbo = YES;

	if (bUseFbo) {
		// レンダリングターゲットをFBOに変更
		[self changeRenderTargetToFBO];
		// オブジェクトをレンダリング
		[self renderObjects];
		// レンダリングターゲットを通常のフレームバッファに変更
		[_fboBase setDefaultFbo];
		[view bindDrawable];
	}
	// ビューポートを設定
	CGSize viewSize = [VArrayBase getScreenSize];
	glViewport(0, 0, viewSize.width, viewSize.height);
	
	// レンダリングバッファをクリア
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	
	if (bUseFbo) {
		[_fboBase render];
	}
	else {
		[self renderObjects];
	}
	
    
}

@end
