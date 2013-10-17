//
//  SimpleTexture.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/17/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "ShaderBase.h"
enum {
	ATTR_SIMPLE_TEXTURE_POSITION = 0,
	ATTR_SIMPLE_TEXTURE_TEXCOORD,
};

enum {
	UNI_SIMPLE_TEXTURE_TRANS = 0,
	UNI_SIMPLE_TEXTURE_SAMPLER,
	UNI_SIMPLE_TEXTURE_NUM,
};

@interface SimpleTextureShader : ShaderBase
{
	
}
- (GLint) getUniformIndex: (int) index;

@end
