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
#import "SimpleTriangleShader.h"
#import "SimpleTriangleBuffer.h"

@interface GameViewController () {
	ShaderBase* _shader;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
	
	GLKVector4 _vTrance;

	VArrayBase *_vArray;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;

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

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
	_shader = [[SimpleTriangleShader alloc] init];
	[_shader loadShaderWithVsh:@"ShaderSimpleTriangle" withFsh:@"Shader"];
    
    self.effect = [[[GLKBaseEffect alloc] init] autorelease];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    
    glEnable(GL_DEPTH_TEST);
	
	_vArray = [[SimpleTriangleBuffer alloc] init];
    [_vArray loadResourceWithName:nil];

	{
		for (int i = 0; i < 4; i++) {
			_vTrance.v[i] = 0.0f;
		}
		_vTrance.y = 1.0f;
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
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
	glBindVertexArrayOES(_vArray.vertexArray);
    
    // Render the object with GLKit
    [self.effect prepareToDraw];
    // こちらはシェーダーを使わない側
    //glDrawArrays(GL_TRIANGLES, 0, _vArray.count);
    
	assert(_shader != nil);
    // Render the object again with ES2
	// シェーダープログラムを適用
    glUseProgram(_shader.programId);
    // シェーダーのユニフォーム変数をセット
	glUniform4fv([_shader getUniformIndex:SIMPLE_TRIANGLE_UNI_TRANCE],
				 1, &_vTrance.x);
    
    glDrawArrays(GL_TRIANGLES, 0, _vArray.count);
}


@end
