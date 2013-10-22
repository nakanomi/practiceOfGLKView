//
//  ColorNoTexShader.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/22/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "ShaderBase.h"

enum {
	ATTRIB_COLORNOTEX_POSITION = 0,
};

enum {
	UNI_COLORNOTEX_COLOR = 0,
	UNI_COLORNOTEX_MATRIX,
	UNI_COLORNOTEX_NUM
};

@interface ColorNoTexShader : ShaderBase
- (GLint) getUniformIndex: (int) index;

@end
