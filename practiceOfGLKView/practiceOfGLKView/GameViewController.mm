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

//#import "SimpleTextureShader.h"
//#import "SimpleTextureVBuffer.h"
//#import "MatrixAndAlpha.h"
#import "SimpleMultiTexture.h"
#import "StarLightScopeShader.h"
#import "PartTextureVBuffer.h"
#import "SimpleDistortion.h"
#import "SimpleDistortion2.h"
#import "SimpleDitortionByPower.h"

#import "SimpleBlur.h"

#import "SimpleFboShader.h"

#import "TextureBase.h"
#import "FboBase.h"

#define _TEST_SQUARE	1
#if _TEST_SQUARE
#import "ColorNoTexShader.h"
#import "ColorNoTexVArray.h"
#endif

#include "gameDefs.h"

//#define _LOOP_NUM	300
#define _LOOP_NUM	3
#define _TEST_ALPHA	1.0f
enum {
	_FBO_FINAL = 0,
	_FBO_PREVIOUS,
	_FBO_NUM
};

enum {
	_MULTEX_BASE = 0,
	_MULTEX_EFFECT_01,
	_MULTEX_EFFECT_02,
	_MULTEX_NUM
};

@interface GameViewController ()
{
	ShaderBase* _shader;
    
	// ユニフォーム変数として設定する位置情報。独立させていないと正常に表示されない？
	GLKVector4 _vTrance[_FBO_NUM][_LOOP_NUM];
	GLKMatrix4 _matrix4[_FBO_NUM][_LOOP_NUM];
	
	VArrayBase *_vArray;
	//	GLuint _textureId;
	TextureBase *_texture[_MULTEX_NUM];
	
    CADisplayLink *_displayLink;
	BOOL _animating;
	int _animationFrameInterval;
	
	// フレームバッファにレンダリングするためのFBO
	FboBase *_fboFinal;
	FboBase *_fbo0;
	
	// ランループの途中でテクスチャ読み込みをするためのカウンタ
	int _testCount;
	
	float _testOffset;
	
	GAMEVIEW_SHADER _setupShader;
	
	BOOL _isLogRect;
	BOOL _isDone;
	
#if _TEST_SQUARE
	ColorNoTexShader *_shaderNoTex;
	ColorNoTexVArray *_vArrayNoTex;
	GLKMatrix4 _matrixSquare;
	GLKVector4 _vColor;
#endif
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;
- (void)checkHeightOfScreen;

- (void)startAnimation;
- (void)endAnimation;
- (void)drawFrame;
- (void)changeRenderTargetToFBO:(FboBase*)targetFbo;
- (void)setupTextures:(int)count;
- (void)renderObjectsForFboIndex:(int)fboIndex;
- (void)renderStarLightFbo;
- (void)render2PassFbo;
- (void)setTextureParametries;

- (void)setupFBO;
- (void)setupDrawObjects;

- (void)drawType00ForView:(GLKView*)view;
- (void)drawType01ForView:(GLKView*)view;
@end

@implementation GameViewController
@synthesize setupShader = _setupShader;

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
		_setupShader = NONE;
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
	
	_isLogRect = NO;
	_isDone = NO;
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
	_shader = nil;
	switch (self.setupShader) {
			// マルチテクスチャ
		case OVERLAY:
		case DODGE:
		case BURN:
		case ADD:
			_shader = [[SimpleMultiTexture alloc] init];
			break;
		case BLUR_TEST_5DOT:
			_shader = [[SimpleBlur alloc] init];
			break;
		case DISTORTION_1_1:
		case DISTORTION_1_2:
			_shader = [[SimpleDistortion alloc] init];
			break;
		case DISTORTION_2_1:
		case DISTORTION_2_2:
			_shader = [[SimpleDistortion2 alloc] init];
			break;
			case DISTORTION_3_1:
			_shader = [[SimpleDitortionByPower alloc] init];
			break;
		case OFF_GRADATION:
			_shader = [[SimpleTextureShader alloc] init];
			break;
		case STAR_LIGHT_SCOPE:
			_shader = [[StarLightScopeShader alloc] init];
			break;
			
		default:
			assert(false);
			break;
	}
	assert(_shader != nil);
    
	NSString *strFragShader = nil;
	switch (self.setupShader) {
		case OVERLAY:
			strFragShader = @"ShaderSimpleOverlay";
			break;
		case DODGE:
			strFragShader = @"ShaderSimpleDodge";
			break;
		case BURN:
			strFragShader = @"ShaderSimpleBurn";
			break;
		case BLUR_TEST_5DOT:
			strFragShader = @"ShaderSimpleBlur";
			break;
		case ADD:
			strFragShader = @"ShaderSimpleMultiAdd";
			break;
		case OFF_GRADATION:
			strFragShader = @"ShaderOffGradation";
			break;
		case DISTORTION_1_1:
		case DISTORTION_1_2:
			strFragShader = @"ShaderSimpleDistortion";
			break;
		case DISTORTION_2_1:
		case DISTORTION_2_2:
			strFragShader = @"ShaderSimpleDistortion2";
			break;
		case DISTORTION_3_1:
			strFragShader = @"ShaderSimpleDistortionByPower";
			break;
		case STAR_LIGHT_SCOPE:
			strFragShader = @"ShaderStarLightScope";
			break;
			
		default:
			assert(false);
			break;
	}
	[_shader loadShaderWithVsh:@"ShaderSimpleTexture" withFsh:strFragShader];
    
    glEnable(GL_DEPTH_TEST);
	
	//[self setupDrawObjects];
	{
		for (int fboIndex = 0; fboIndex < _FBO_NUM; fboIndex++) {
			for (int index = 0; index < _LOOP_NUM; index++) {
				for (int i = 0; i < 4; i++) {
					_vTrance[fboIndex][index].v[i] = 0.0f;
				}
				_vTrance[fboIndex][index].y = 0.0f;
				_matrix4[fboIndex][index] = GLKMatrix4Identity;
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
	_testCount = 0;
	_testOffset = 0.0f;
	{
		GLint param = 0;
		glGetIntegerv(GL_MAX_TEXTURE_IMAGE_UNITS, &param);
		NSLog(@"texunit:%d", param);
	}
#if _TEST_SQUARE
	{
		_shaderNoTex = [[ColorNoTexShader alloc] init];
		[_shaderNoTex loadShaderWithVsh:@"ShaderColorMtrxNoTex" withFsh:@"ShaderColorMtrxNoTex"];
		CGRect rect = CGRectMake(128, 128, 40, 50);
		_vArrayNoTex = [[ColorNoTexVArray alloc] init];
		[_vArrayNoTex setupMatrixByRectangle:rect withRenderTargetSize:_fbo0.sizeFbo matrix:&_matrixSquare isDebug:NO];
		[_vArrayNoTex loadResourceWithName:nil];
		_vColor = GLKVector4Make(1.0f, 1.0f, 0.0f, 0.8f);
	}
#endif
}

- (void)setupDrawObjects
{
	if (_testCount > 1)
	{
		if (!_isDone) {
			_isDone = YES;
			{
				NSString* filesForStarLightScope[] = {
					@"bg",
					@"shadowup",
					@"scanline",
				};
				NSString* filesForDistortionx_1[] = {
					@"bg",
					@"shadowup",
					@"scanline",
				};
				NSString* filesForDistortionx_2[] = {
					@"bg",
					@"distortionmap",
					@"scanline",
				};
				NSString* filesForDistortion2_1[] = {
					@"bg2",
					@"distortionmap2",
					@"scanline",
				};
				NSString* filesForDistortion3_1[] = {
					@"bg2",
					@"distortionCircle2",
					@"scanline",
				};
				NSString** files = nil;
				switch (self.setupShader) {
					case STAR_LIGHT_SCOPE:
						files = filesForStarLightScope;
						break;
					case DISTORTION_1_2:
					case DISTORTION_2_2:
						files = filesForDistortionx_2;
						break;
					case DISTORTION_2_1:
						files = filesForDistortion2_1;
						break;
					case DISTORTION_3_1:
						files = filesForDistortion3_1;
						break;
						
					default:
						files = filesForDistortionx_1;
						break;
				}
				NSString* exts[] = {
					@"png",
					@"png",
					@"png",
				};
				int i;
				for (i = 0; i < _MULTEX_NUM; i++) {
					_texture[i] = [[TextureBase alloc] init];
					BOOL loadResult = [_texture[i] loadTextureFromName:files[i] ofType:exts[i]];
					assert(loadResult);
				}
				
			}
			{
				_vArray = [[PartTextureVBuffer alloc] init];
				//CGSize sizeTexture = CGSizeMake(16.0f, 16.0f);
				//CGSize sizeRenderBuffer = _fboFinal.sizeFbo;
				PartTextureVBuffer *vArrayBuffer = (PartTextureVBuffer*)_vArray;
				//[simpleVArray setupVerticesByTexSize:_texture.textureSize withRenderBufferSize:sizeRenderBuffer];
				//CGRect rectPart = CGRectMake(80.0f, 94.0f, 16.0f, 16.0f);
				CGRect rectPart = CGRectMake(0.0f, 0.0f, 256.0f, 256.0f);
				[vArrayBuffer setupVerticesByTexPart:rectPart withTexSize:_texture[_MULTEX_BASE].textureSize withRenderTargetSize:_fbo0.sizeFbo isDebug:NO];
			}
			
			[_vArray loadResourceWithName:nil];
		}
	}
	else {
		_testCount++;
	}
}


- (void)setupFBO
{
	_fboFinal = [[FboBase alloc] init];
	CGSize size = CGSizeMake(256.0f, 256.0f);
	[_fboFinal setupFboWithSize:size withRenderTarget:[VArrayBase getScreenSize]];
	_fboFinal.clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
	
	_fbo0 = [[FboBase alloc] init];
	[_fbo0 setupFboWithSize:size withRenderTarget:size];
	_fbo0.clearColor = GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);
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
	{
		int i;
		for (i = 0; i < _MULTEX_NUM; i++) {
			if (_texture[i] != nil) {
				[_texture[i] release];
				_texture[i] = nil;
			}
		}
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

- (void)setupTextures:(int)count
{
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, _texture[_MULTEX_BASE].textureId);
	if (count >= 2) {
		glActiveTexture(GL_TEXTURE1);
		glBindTexture(GL_TEXTURE_2D, _texture[_MULTEX_EFFECT_01].textureId);
	}
	if (count >= 3) {
		glActiveTexture(GL_TEXTURE2);
		glBindTexture(GL_TEXTURE_2D, _texture[_MULTEX_EFFECT_02].textureId);
	}
	
}

- (void)setTextureParametries
{
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}


- (void)renderStarLightFbo
{
	[self changeRenderTargetToFBO:_fboFinal];
	assert(_shader != nil);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	// 頂点バッファを選択
	glBindVertexArrayOES(_vArray.vertexArray);
    
	// シェーダープログラムを適用
    glUseProgram(_shader.programId);
	[self setupTextures:_shader.textureCount];
	StarLightScopeShader *shaderStar = (StarLightScopeShader*)(_shader);
	[shaderStar setUniformsOnRenderWithParam:0.0f pass:0];
	
	// テクスチャの補間をしない。この設定はglDrawArraysごとに設定し直す必要があるらしい
	[self setTextureParametries];
	//glDrawArrays(GL_TRIANGLES, 0, _vArray.count);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, _vArray.count);
}

- (void)render2PassFbo
{
#if 1
	// ************ 注意 *************
	// ここでは簡単にするため描画対象が一つしかないので、いきなりフィルター処理に入っているが
	// ぼかしなどは本来、シーン全体をレンダリングしてからかけることに注意
	// ************ pass1 *************
	[self changeRenderTargetToFBO:_fbo0];
	assert(_shader != nil);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	// 頂点バッファを選択
	glBindVertexArrayOES(_vArray.vertexArray);
    
	// シェーダープログラムを適用
    glUseProgram(_shader.programId);
	[_shader setUniformsOnRenderWithParam:0.0f pass:0];
	[self setupTextures:_shader.textureCount];
	
	// テクスチャの補間をしない。この設定はglDrawArraysごとに設定し直す必要があるらしい
	[self setTextureParametries];
	//glDrawArrays(GL_TRIANGLES, 0, _vArray.count);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, _vArray.count);
	
	
	// ************ pass1 *************
	[self changeRenderTargetToFBO:_fboFinal];
	glUseProgram(_shader.programId);
	[_shader setUniformsOnRenderWithParam:0.0f pass:1];
	[_fbo0 bindVertex];
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, _fbo0.texId);
	[self setTextureParametries];
	glDrawArrays(GL_TRIANGLE_STRIP, 0, _fbo0.countVertice);
#else
	[self changeRenderTargetToFBO:_fboFinal];
	glUseProgram(_shader.programId);
	[_shader setUniformsOnRenderWithParam:0.0f pass:1];
	// 頂点バッファを選択
	glBindVertexArrayOES(_vArray.vertexArray);
	glActiveTexture(GL_TEXTURE0);
	[self setupTextures:_shader.textureCount];
	[self setTextureParametries];
	glDrawArrays(GL_TRIANGLE_STRIP, 0, _fbo0.countVertice);
#endif
	
}


- (void)renderObjectsForFboIndex:(int)fboIndex;
{
	[self changeRenderTargetToFBO:_fboFinal];
    // Render the object with GLKit
    
	assert(_shader != nil);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	// 頂点バッファを選択
	glBindVertexArrayOES(_vArray.vertexArray);
    
	// シェーダープログラムを適用
    glUseProgram(_shader.programId);
	[self setupTextures:_shader.textureCount];
	
	_vTrance[fboIndex][0].x = -1.0f;
	for (int i = 1; i < _LOOP_NUM; i++) {
		_vTrance[fboIndex][i].x = _vTrance[fboIndex][i - 1].x + (2.0f / (float)_LOOP_NUM);
		switch (fboIndex) {
			case _FBO_PREVIOUS:
				_vTrance[fboIndex][i].y = _testOffset + (_vTrance[fboIndex][i - 1].y + (1.0f / (float)_LOOP_NUM));
				break;
			case _FBO_FINAL:
				_vTrance[fboIndex][i].y = _testOffset + ( _vTrance[fboIndex][i - 1].y - (1.0f / (float)_LOOP_NUM));
				break;
				
			default:
				assert(false);
				break;
		}
	}
	_testOffset += 1.0f/4096.0f;
	switch (self.setupShader) {
		case DISTORTION_1_1:
		case DISTORTION_1_2:
		{
			float testTheta = fmodf(_testOffset * 256.0f, M_PI * 2.0f);
			float sinVal = sinf(testTheta);
			//dbgLog(@"sin:%f", sinVal);
			float mag = sinVal * (50.0f / 255.0f);
			[_shader setUniformsOnRenderWithParam:mag pass:0];
		}
			break;
		case DISTORTION_2_1:
		case DISTORTION_2_2:
		{
			float testTheta = fmodf(_testOffset * 256.0f, M_PI * 2.0f);
			[_shader setUniformsOnRenderWithParam:testTheta pass:0];
		}
			break;
		case DISTORTION_3_1:
		{
			float testTheta = fmodf(_testOffset * 256.0f, M_PI * 2.0f);
			float param = (sinf(testTheta) * 2.0f) + 1.5f;
			[_shader setUniformsOnRenderWithParam:param pass:0];
		}
			break;
			
		default:
			[_shader setUniformsOnRenderWithParam:0.0f pass:0];
			break;
	}
	
	for (int i = 0; i < _LOOP_NUM; i++) {
		// シェーダーのユニフォーム変数をセット
		glUniform1i([_shader getUniformIndex:UNI_SIMPLEMULTI_SAMPLERBASE], 0);
		glUniform1i([_shader getUniformIndex:UNI_SIMPLEMULTI_SAMPLEREFF], 1);
		// テクスチャの補間をしない。この設定はglDrawArraysごとに設定し直す必要があるらしい
		[self setTextureParametries];
		//glDrawArrays(GL_TRIANGLES, 0, _vArray.count);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, _vArray.count);
	}
	//render objects
}


#pragma mark -GLKView delegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	[self setupDrawObjects];
	{
		if (!_isLogRect) {
			_isLogRect = YES;
			NSLog(@"width = %f, height = %f", rect.size.width, rect.size.height);
		}
	}
	//[self drawType00ForView:view];
	[self drawType01ForView:view];
	
    
}

- (void)drawType00ForView:(GLKView*)view
{
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

- (void)drawType01ForView:(GLKView*)view
{
	switch (self.setupShader) {
		case STAR_LIGHT_SCOPE:
			[self renderStarLightFbo];
			break;
		case BLUR_TEST_5DOT:
			[self render2PassFbo];
			break;
			
		default:
			[self renderObjectsForFboIndex:0];
			break;
	}

	// レンダリングターゲットを通常のフレームバッファに変更
	[FboBase setDefaultFbo];
	[view bindDrawable];
	// ビューポートを設定
	CGSize viewSize = [VArrayBase getScreenSize];
	glViewport(0, 0, viewSize.width, viewSize.height);
	
	// レンダリングバッファをクリア
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	[_fboFinal render];
}

@end
