//
//  SimpleEffect.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/10/20.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import "StarLightScopeShader.h"

@interface StarLightScopeShader()
{
	GLint _uniforms[UNI_STARLIGHTSCOPE_NUM];
	GLKVector4 _colorOverlay;
	GLKVector4 _noMoveVec;
}
- (BOOL)setupUniforms;
- (void)initUniforms;

@end

@implementation StarLightScopeShader

- (id)init
{
	self = [super init];
	if (self != nil) {
		_colorOverlay.r = 34.0f/255.0f;
		_colorOverlay.g = 172.0f/255.0f;
		_colorOverlay.b = 56.0f/255.0f;
		_colorOverlay.a = 1.0f;
		_textureCount = 3;
		
		memset(&_noMoveVec, 0, sizeof(_noMoveVec));
	}
	return self;
}


- (GLint) getUniformIndex: (int) index
{
	int result = -1;
	if ((index >= 0) && (index < (sizeof(_uniforms) / sizeof(_uniforms[0])))) {
		result = _uniforms[index];
	}
	return result;
}

- (void)setUniformsToSystem
{
	// シェーダーのユニフォーム変数をセット
	glUniform4fv(_uniforms[UNI_SIMPLE_TEXTURE_TRANS], 1, &_noMoveVec.x);
	glUniform1i(_uniforms[UNI_SIMPLE_TEXTURE_SAMPLER], 0);
	glUniform4fv(_uniforms[UNI_STARLIGHTSCOPE_OVERLAY_GREEN], 1, &_colorOverlay.x);
	glUniform1i(_uniforms[UNI_STARLIGHTSCOPE_SAMPLER_BURN], 1);
	glUniform1i(_uniforms[UNI_STARLIGHTSCOPE_SAMPLER_SCANLINE], 2);
}



- (BOOL)setupUniforms
{
	BOOL result = NO;
	@try {
		// SimpleTexture
		_uniforms[UNI_SIMPLE_TEXTURE_TRANS] = glGetUniformLocation(self.programId, "uniTrance");
		_uniforms[UNI_SIMPLE_TEXTURE_SAMPLER] = glGetUniformLocation(self.programId, "uSamplerBase");
		// StarLightScope
		_uniforms[UNI_STARLIGHTSCOPE_OVERLAY_GREEN] = glGetUniformLocation(self.programId, "uColorOverlay");
		_uniforms[UNI_STARLIGHTSCOPE_SAMPLER_BURN] =  glGetUniformLocation(self.programId, "uSamplerBurn");
		_uniforms[UNI_STARLIGHTSCOPE_SAMPLER_SCANLINE] =  glGetUniformLocation(self.programId, "uSamplerScanLine");
		for (int i = 0; i < UNI_STARLIGHTSCOPE_NUM; i++) {
			assert(_uniforms[i] >= 0);
		}
		result =YES;
	}
	@catch (NSException *exception) {
		
	}
	return result;
}
- (void)initUniforms
{
	for (int index = 0; index < (sizeof(_uniforms) / sizeof(_uniforms[0])); index++) {
		_uniforms[index] = -1;
	}
}


@end
