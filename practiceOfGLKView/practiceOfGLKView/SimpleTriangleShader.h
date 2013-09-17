//
//  SimpleTriangleShader.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/17/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "ShaderBase.h"
enum
{
	ATTRIB_SIMPLE_TR_POSITION = 0,
};

enum  {
	SIMPLE_TRIANGLE_UNI_TRANCE = 0,
	NUM_SIMPLE_TRIANGLE_UNI_
};

@interface SimpleTriangleShader : ShaderBase
{
	
}
- (GLint) getUniformIndex: (int) index;

@end
