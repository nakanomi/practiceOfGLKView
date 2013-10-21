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
}
- (BOOL)setupUniforms;
- (void)initUniforms;

@end

@implementation StarLightScopeShader

- (GLint) getUniformIndex: (int) index
{
	int result = -1;
	if ((index >= 0) && (index < (sizeof(_uniforms) / sizeof(_uniforms[0])))) {
		result = _uniforms[index];
	}
	return result;
}


- (BOOL)setupUniforms
{
	BOOL result = NO;
	@try {
		// SimpleTexture
		_uniforms[UNI_SIMPLE_TEXTURE_TRANS] = glGetUniformLocation(self.programId, "uniTrance");
		_uniforms[UNI_SIMPLE_TEXTURE_SAMPLER] = glGetUniformLocation(self.programId, "uSampler");
		// StarLightScope
		_uniforms[UNI_STARLIGHTSCOPE_OVERLAY_GREEN] = glGetUniformLocation(self.programId, "uColorOverlay");
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
