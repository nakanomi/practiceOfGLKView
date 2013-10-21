//
//  SimpleEffect.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/10/20.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import "SimpleTextureShader.h"

enum {
	UNI_STARLIGHTSCOPE_OVERLAY_GREEN = UNI_SIMPLE_TEXTURE_NUM,
	UNI_STARLIGHTSCOPE_NUM
};

@interface StarLightScopeShader : SimpleTextureShader
- (id)init;
- (GLint) getUniformIndex: (int) index;
- (void)setUniformsToSystem;

@end
