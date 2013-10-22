//
//  ColorNoTexShader.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/22/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "ColorNoTexShader.h"
@interface ColorNoTexShader()
{
	GLint _uniforms[UNI_COLORNOTEX_NUM];
}
@end


@implementation ColorNoTexShader
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
		glBindAttribLocation(self.programId, ATTRIB_COLORNOTEX_POSITION, "position");
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
		_uniforms[UNI_COLORNOTEX_COLOR] = glGetUniformLocation(self.programId, "color");
		_uniforms[UNI_COLORNOTEX_MATRIX] = glGetUniformLocation(self.programId, "affineMatrix");
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
