//
//  MyShader.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/15.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import "MyShader.h"
@interface MyShader()
{
	GLint _uniforms[NUM_UNIFORMS];	
}
- (BOOL)setupAttributes;
- (BOOL)setupUniforms;
- (void)initUniforms;

@end

@implementation MyShader

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
		glBindAttribLocation(self.programId, ATTRIB_VERTEX, "position");
		glBindAttribLocation(self.programId, ATTRIB_NORMAL, "normal");
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
		_uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(self.programId, "modelViewProjectionMatrix");
		_uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(self.programId, "normalMatrix");
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
