//
//  SimpleTriangleShader.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/17/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "SimpleTriangleShader.h"

@interface SimpleTriangleShader()
{
	GLint _uniforms[NUM_SIMPLE_TRIANGLE_UNI_];
}
- (BOOL)setupAttributes;
- (BOOL)setupUniforms;
- (void)initUniforms;

@end

@implementation SimpleTriangleShader

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
		glBindAttribLocation(self.programId, ATTRIB_SIMPLE_TR_POSITION, "position");
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
		_uniforms[SIMPLE_TRIANGLE_UNI_TRANCE] = glGetUniformLocation(self.programId, "uniTrance");
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
