//
//  SimpleFboShader.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/4/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "ShaderBase.h"
enum {
	ATTR_SIMPLE_FBO_POSITION = 0,
	ATTR_SIMPLE_FBO_TEXCOORD,
};

@interface SimpleFboShader : ShaderBase
{
	
}
- (GLint) getUniformIndex: (int) index;

@end
