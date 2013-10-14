//
//  MatrixAndAlpha.mm
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/14/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "MatrixAndAlpha.h"

@interface MatrixAndAlpha()
{
	GLint _uniforms[UNI_MATRIX_AND_ALPHA_NUM];
}

@end

@implementation MatrixAndAlpha
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
		glBindAttribLocation(self.programId, ATTR_MATRIX_AND_ALPHA_POSITION, "position");
		glBindAttribLocation(self.programId, ATTR_MATRIX_AND_ALPHA_TEXCOORD, "texcoord");
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
		_uniforms[UNI_MATRIX_AND_ALPHA_MATRIX] = glGetUniformLocation(self.programId, "affineMatrix");
		_uniforms[UNI_MATRIX_AND_ALPHA_ALPHA] = glGetUniformLocation(self.programId, "uAlpha");
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
