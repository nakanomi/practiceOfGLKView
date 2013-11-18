//
//  FboBase.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/10/05.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import "FboBase.h"
#import "SimpleFboShader.h"
//#import "FboTextureBuffer.h"
//#import "SimpleTextureVBuffer.h"ba
#import "SimpleFboVBuffer.h"
#include "gameDefs.h"

static GLint sDefaultFbo = -1;

@interface FboBase()
{
	SimpleFboShader* _fboShader;
	SimpleFboVBuffer* _fboVArray;

	GLuint _fboHandle;
	GLuint _fboTexId;
	GLuint _fboDepthBuffer;
	
	CGSize _sizeFbo;
}
@end


@implementation FboBase
@synthesize sizeFbo = _sizeFbo;
@synthesize texId = _fboTexId;
-(id)init
{
	self = [super init];
	if (self != nil) {
		_clearColor.r =
		_clearColor.g =
		_clearColor.b =
		_clearColor.a = 0.0f;
	}
	return self;
}

- (void)dealloc
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	NSLog(@"tex %d now released", _fboTexId);
	glDeleteTextures(1, &_fboTexId);
	glDeleteBuffers(1, &_fboDepthBuffer);
	glDeleteBuffers(1, &_fboHandle);
	if (_fboVArray != nil) {
		[_fboVArray release];
	}
	if (_fboShader != nil) {
		[_fboShader release];
	}
	[super dealloc];
}


- (void)setupFboWithSize:(CGSize)sizeFbo withRenderTarget:(CGSize)sizeRenderTarget;
{
	{
		CGRect rectFbo = CGRectMake(0.0f, 0.0f, sizeFbo.width, sizeFbo.height);
		CGPoint posCenter = CGPointMake(sizeRenderTarget.width * 0.5f, sizeRenderTarget.height * 0.5f);
		float halfWidth = sizeFbo.width * 0.5f;
		float halfHeight = sizeFbo.height * 0.5f;
		CGRect rectRender = CGRectMake(posCenter.x - halfWidth , posCenter.y - halfHeight,
									   sizeFbo.width, sizeFbo.height);
		[self setupPartFboWithSize:sizeFbo withRenderTarget:sizeRenderTarget
					withRenderPart:rectRender withFboPart:rectFbo];
	}
}

- (void)setupPartFboWithSize:(CGSize)sizeFbo withRenderTarget:(CGSize)sizeRenderTarget withRenderPart:(CGRect)rectRende withFboPart:(CGRect)rectFbo
{
	_sizeFbo.width = sizeFbo.width;
	_sizeFbo.height = sizeFbo.height;
	if (sDefaultFbo < 0) {
		glGetIntegerv(GL_FRAMEBUFFER_BINDING, &sDefaultFbo);
	}
	
	glGenFramebuffers(1, &_fboHandle);
	glGenTextures(1, &_fboTexId);
	NSLog(@"tex %d now allocated for fbo at %s", _fboTexId, __PRETTY_FUNCTION__);
	glGenRenderbuffers(1, &_fboDepthBuffer);
	
	glBindFramebuffer(GL_FRAMEBUFFER, _fboHandle);
	glBindTexture(GL_TEXTURE_2D, _fboTexId);
	glTexImage2D(GL_TEXTURE_2D,
				 0,
				 GL_RGBA,
				 _sizeFbo.width, _sizeFbo.height,
				 0,
				 GL_RGBA,
				 GL_UNSIGNED_BYTE,
				 NULL);
	// テクスチャの補間をしない
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
						   GL_TEXTURE_2D, _fboTexId, 0);
	glBindRenderbuffer(GL_RENDERBUFFER, _fboDepthBuffer);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16_OES, _sizeFbo.width, _sizeFbo.height);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _fboDepthBuffer);
	GLenum status;
	status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    switch(status) {
        case GL_FRAMEBUFFER_COMPLETE:
            NSLog(@"fbo complete");
            break;
            
        case GL_FRAMEBUFFER_UNSUPPORTED:
            NSLog(@"fbo unsupported");
            break;
            
        default:
            /* programming error; will fail on all hardware */
            NSLog(@"Framebuffer Error");
            break;
    }
	glBindFramebuffer(GL_FRAMEBUFFER, sDefaultFbo);
	
	_fboShader = [[SimpleFboShader alloc] init];
	[_fboShader loadShaderWithVsh:@"ShaderSimpleFbo" withFsh:@"ShaderAlphaCancelTexture"];
	_fboVArray = [[SimpleFboVBuffer alloc] init];
	{
		[_fboVArray setupPartFboWithSize:sizeFbo withRenderTarget:sizeRenderTarget withRenderPart:rectRende withFboPart:rectFbo];
		[_fboVArray loadResourceWithName:nil];
	}
}
- (void)bindVertex
{
	glBindVertexArrayOES(_fboVArray.vertexArray);
}


- (void)changeRenderTargetToFBO
{
	glBindTexture(GL_TEXTURE_2D, 0);
	glEnable(GL_TEXTURE_2D);
	glBindFramebuffer(GL_FRAMEBUFFER, _fboHandle);
	glViewport(0, 0, _sizeFbo.width, _sizeFbo.height);
	glClearColor(self.clearColor.r, self.clearColor.g, self.clearColor.b, self.clearColor.a);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}
- (void)render
{
	glUseProgram(_fboShader.programId);
	[self bindVertex];
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, _fboTexId);
	// テクスチャの補間をしない。この設定はglDrawArraysごとに設定し直す必要があるらしい
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, _fboVArray.count);
}

- (GLsizei) countVertice
{
	GLsizei result = 0;
	if (_fboVArray != nil) {
		result = _fboVArray.count;
	}
	return result;
}

+ (void)setDefaultFbo
{
	// レンダリングターゲットを通常のフレームバッファに変更
	glBindFramebuffer(GL_FRAMEBUFFER, sDefaultFbo);
}



@end
