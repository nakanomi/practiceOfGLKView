//
//  SimpleTexture.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/17/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "SimpleTextureShader.h"
@interface SimpleTextureShader()
{
	GLint _uniforms[UNI_SIMPLE_TEXTURE_NUM];
}
- (BOOL)setupAttributes;
- (BOOL)setupUniforms;
- (void)initUniforms;
@end

@implementation SimpleTextureShader
- (GLint) getUniformIndex: (int) index
{
	int result = -1;
	if ((index >= 0) && (index < (sizeof(_uniforms) / sizeof(_uniforms[0])))) {
		result = _uniforms[index];
	}
	return result;
}

- (BOOL)setupAttributes
{
	BOOL result = NO;
	@try {
		glBindAttribLocation(self.programId, ATTR_SIMPLE_TEXTURE_POSITION, "position");
		glBindAttribLocation(self.programId, ATTR_SIMPLE_TEXTURE_TEXCOORD, "texcoord");
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
		_uniforms[UNI_SIMPLE_TEXTURE_TRANS] = glGetUniformLocation(self.programId, "uniTrance");
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
