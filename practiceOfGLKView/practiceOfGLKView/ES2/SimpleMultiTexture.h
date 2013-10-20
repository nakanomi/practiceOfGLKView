//
//  SimpleMultiTexture.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/17/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "ShaderBase.h"
enum {
	ATTR_SIMPLEMULTI_POSITION = 0,
	ATTR_SIMPLEMULTI_TEXCOORD,
};

enum  {
	UNI_SIMPLEMULTI_SAMPLERBASE = 0,
	UNI_SIMPLEMULTI_SAMPLEREFF,
	UNI_SIMPLEMULTI_NUM
};

@interface SimpleMultiTexture : ShaderBase
{
	
}
- (id)init;
- (GLint) getUniformIndex: (int) index;

@end
