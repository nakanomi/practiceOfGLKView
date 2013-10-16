//
//  MatrixAndAlpha.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/14/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "ShaderBase.h"
enum {
	ATTR_MATRIX_AND_ALPHA_POSITION = 0,
	ATTR_MATRIX_AND_ALPHA_TEXCOORD,
};

enum  {
	UNI_MATRIX_AND_ALPHA_ALPHA = 0,
	UNI_MATRIX_AND_ALPHA_MATRIX,
	UNI_MATRIX_AND_ALPHA_SAMPLER,
	UNI_MATRIX_AND_ALPHA_NUM
};

@interface MatrixAndAlpha : ShaderBase

@end
