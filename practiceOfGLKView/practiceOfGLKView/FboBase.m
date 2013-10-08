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
#import "SimpleTextureBuffer.h"

static GLint sDefaultFbo = -1;

@interface FboBase()
{
	GLint _width;
	GLint _height;
	SimpleFboShader* _fboShader;
	SimpleTextureBuffer* _fboVArray;

	GLuint _fboHandle;
	GLuint _fboTexId;
	GLuint _fboDepthBuffer;
	
	CGSize _sizeFbo;
}
@end


@implementation FboBase
@synthesize width = _width;
@synthesize height = _height;

-(id)init
{
	self = [super init];
	if (self != nil) {
	}
	return self;
}

- (void)dealloc
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	glDeleteTextures(1, &_fboTexId);
	glDeleteBuffers(1, &_fboDepthBuffer);
	glDeleteBuffers(1, &_fboHandle);
	if (_fboVArray != nil) {
		[_fboVArray release];
	}
	[super dealloc];
}


- (void)setupFboWithSize:(CGSize)size
{
	_sizeFbo.width = size.width;
	_sizeFbo.height = size.height;
	if (sDefaultFbo < 0) {
		glGetIntegerv(GL_FRAMEBUFFER_BINDING, &sDefaultFbo);
	}
	
	glGenFramebuffers(1, &_fboHandle);
	glGenTextures(1, &_fboTexId);
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
	[_fboShader loadShaderWithVsh:@"ShaderSimpleFbo" withFsh:@"ShaderSimpleTexture"];
	_fboVArray = [[SimpleTextureBuffer alloc] init];
	{
		// レンダリング先は通常のフレームバッファで、そこにドットバイドット表示とする
		CGSize sizeRenderBuffer = [VArrayBase getScreenSize];
		[_fboVArray setupVerticesByTexSize:_sizeFbo withRenderBufferSize:sizeRenderBuffer];
		[_fboVArray loadResourceWithName:nil];
	}
	//[_fboVArray loadResourceWithName:nil];
}

- (void)changeRenderTargetToFBO
{
	glBindTexture(GL_TEXTURE_2D, 0);
	glEnable(GL_TEXTURE_2D);
	glBindFramebuffer(GL_FRAMEBUFFER, _fboHandle);
	glViewport(0, 0, _sizeFbo.width, _sizeFbo.height);
	glClearColor(1.0, 1.0, 1.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}
- (void)setDefaultFbo
{
	// レンダリングターゲットを通常のフレームバッファに変更
	glBindFramebuffer(GL_FRAMEBUFFER, sDefaultFbo);
}
- (void)render
{
	glUseProgram(_fboShader.programId);
	glBindVertexArrayOES(_fboVArray.vertexArray);
	glBindTexture(GL_TEXTURE_2D, _fboTexId);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, _fboVArray.count);
}



@end
