//
//  SimpleMultiTexture.mm
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/17/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "SimpleMultiTexture.h"

@interface SimpleMultiTexture()
{
	GLint _uniforms[UNI_SIMPLEMULTI_NUM];
}

@end

@implementation SimpleMultiTexture
- (GLint) getUniformIndex: (int) index
{
	GLint result = -1;
	if ((index >= 0) && (index < (sizeof(_uniforms) / sizeof(_uniforms[0])))) {
		result = _uniforms[index];
	}
	return result;
}

- (BOOL)setupAttributes
{
	BOOL result = NO;
	@try {
		glBindAttribLocation(self.programId, ATTR_SIMPLEMULTI_POSITION, "position");
		glBindAttribLocation(self.programId, ATTR_SIMPLEMULTI_TEXCOORD, "texcoord");
		result =YES;
	}
	@catch (NSException *exception) {
		
	}
	return result;
}

- (BOOL)setupUniforms
{
	BOOL result = NO;
	@try {
		[self initUniforms];
		_uniforms[UNI_SIMPLEMULTI_SAMPLERBASE] = glGetUniformLocation(self.programId, "uSamplerBase");
		_uniforms[UNI_SIMPLEMULTI_SAMPLEREFF] = glGetUniformLocation(self.programId, "uSamplerEff");
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
