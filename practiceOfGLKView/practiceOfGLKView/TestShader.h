//
//  MyShader.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/15.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import "ShaderBase.h"
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};



@interface TestShader : ShaderBase
{
	
}
- (GLint) getUniformIndex: (int) index;

@end
