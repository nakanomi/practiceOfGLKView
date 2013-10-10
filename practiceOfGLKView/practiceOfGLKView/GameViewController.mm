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

#import "SimpleTextureShader.h"
//#import "SimpleTextureVBuffer.h"
#import "PartTextureVBuffer.h"

#import "SimpleFboShader.h"

#import "TextureBase.h"
#import "FboBase.h"

//#define _LOOP_NUM	300
#define _LOOP_NUM	3
enum {
	_FBO_FINAL = 0,
	_FBO_PREVIOUS,
	_FBO_NUM
};

@interface GameViewController ()
{
	ShaderBase* _shader;
    
	// ユニフォーム変数として設定する位置情報。独立させていないと正常に表示されない？
	GLKVector4 _vTrance[_FBO_NUM][_LOOP_NUM];
	
	VArrayBase *_vArray;
	//	GLuint _textureId;
	TextureBase *_texture;
	
    CADisplayLink *_displayLink;
	BOOL _animating;
	int _animationFrameInterval;
	
	// フレームバッファにレンダリングするためのFBO
	FboBase *_fboFinal;
	FboBase *_fbo0;
	 
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;
- (void)checkHeightOfScreen;

- (void)startAnimation;
- (void)endAnimation;
- (void)drawFrame;
- (void)changeRenderTargetToFBO:(FboBase*)targetFbo;
- (void)renderObjectsForFboIndex:(int)fboIndex;

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
#if 0
-(id)retain
{
	NSLog(@"%@", [NSThread callStackSymbols]);
	return ([super retain]);
}

-(oneway void)release
{
	NSLog(@"%@", [NSThread callStackSymbols]);
	[super release];
}
#endif
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

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self endAnimation];
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
	
	{
		_texture = [[TextureBase alloc] init];
		BOOL loadResult = [_texture loadTextureFromName:@"BG002" ofType:@"png"];
		assert(loadResult);
		
	}
	{
		_vArray = [[PartTextureVBuffer alloc] init];
		//CGSize sizeTexture = CGSizeMake(16.0f, 16.0f);
		//CGSize sizeRenderBuffer = _fboFinal.sizeFbo;
		PartTextureVBuffer *vArrayBuffer = (PartTextureVBuffer*)_vArray;
		//[simpleVArray setupVerticesByTexSize:_texture.textureSize withRenderBufferSize:sizeRenderBuffer];
		CGRect rectPart = CGRectMake(80.0f, 94.0f, 16.0f, 16.0f);
		[vArrayBuffer setupVerticesByTexPart:rectPart withTexSize:_texture.textureSize withRenderTargetSize:_fbo0.sizeFbo];
	}

    [_vArray loadResourceWithName:nil];
	
	{
		for (int fboIndex = 0; fboIndex < _FBO_NUM; fboIndex++) {
			for (int index = 0; index < _LOOP_NUM; index++) {
				for (int i = 0; i < 4; i++) {
					_vTrance[fboIndex][index].v[i] = 0.0f;
				}
				_vTrance[fboIndex][index].y = 0.0f;
			}
		}
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
	_fboFinal = [[FboBase alloc] init];
	CGSize size = CGSizeMake(512.0f, 512.0f);
	[_fboFinal setupFboWithSize:size withRenderTarget:[VArrayBase getScreenSize]];
	_fboFinal.clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f);
	
	_fbo0 = [[FboBase alloc] init];
	[_fbo0 setupFboWithSize:size withRenderTarget:size];
	_fbo0.clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f);
}


- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
	[_fboFinal release];
	[_fbo0 release];
    
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

- (void)changeRenderTargetToFBO:(FboBase*)targetFbo;
{
	[targetFbo changeRenderTargetToFBO];
	
}

- (void)renderObjectsForFboIndex:(int)fboIndex;
{
    // Render the object with GLKit
    
	assert(_shader != nil);
	
	// 頂点バッファを選択
	glBindVertexArrayOES(_vArray.vertexArray);
    
	// シェーダープログラムを適用
    glUseProgram(_shader.programId);
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, _texture.textureId);
	
	_vTrance[fboIndex][0].x = -1.0f;
	for (int i = 1; i < _LOOP_NUM; i++) {
		_vTrance[fboIndex][i].x = _vTrance[fboIndex][i - 1].x + (2.0f / (float)_LOOP_NUM);
		switch (fboIndex) {
			case _FBO_PREVIOUS:
				_vTrance[fboIndex][i].y = _vTrance[fboIndex][i - 1].y + (1.0f / (float)_LOOP_NUM);
				break;
			case _FBO_FINAL:
				_vTrance[fboIndex][i].y = _vTrance[fboIndex][i - 1].y - (1.0f / (float)_LOOP_NUM);
				break;
				
			default:
				assert(false);
				break;
		}
	}
	
	for (int i = 0; i < _LOOP_NUM; i++) {
		// シェーダーのユニフォーム変数をセット
		glUniform4fv([_shader getUniformIndex:UNI_SIMPLE_TEXTURE_TRANS],
					 1, &_vTrance[fboIndex][i].x);
		
		// テクスチャの補間をしない。この設定はglDrawArraysごとに設定し直す必要があるらしい
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
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
		[self changeRenderTargetToFBO:_fbo0];
		// オブジェクトをレンダリング
		[self renderObjectsForFboIndex:_FBO_PREVIOUS];
		// 最終Fboに、それ以前用のFBOをレンダリング
		[self changeRenderTargetToFBO:_fboFinal];
		glDisable(GL_DEPTH_TEST);
		[_fbo0 render];
		glEnable(GL_DEPTH_TEST);
		[self renderObjectsForFboIndex:_FBO_FINAL];
		// レンダリングターゲットを通常のフレームバッファに変更
		[FboBase setDefaultFbo];
		[view bindDrawable];
		
	}
	// ビューポートを設定
	CGSize viewSize = [VArrayBase getScreenSize];
	glViewport(0, 0, viewSize.width, viewSize.height);
	
	// レンダリングバッファをクリア
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	
	if (bUseFbo) {
		[_fboFinal render];
	}
	else {
		[self renderObjectsForFboIndex:0];
	}
	
    
}

@end
