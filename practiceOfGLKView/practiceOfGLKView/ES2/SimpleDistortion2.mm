//
//  SimpleDistortion2.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 11/6/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "SimpleDistortion2.h"
#include "gameDefs.h"

enum {
	UNI_SIMPLEDISTORTION2_VMAG = UNI_SIMPLEMULTI_NUM,
	UNI_SIMPLEDISTORTION2_NUM
};

@interface SimpleDistortion2()
{
	GLint _uniforms[UNI_SIMPLEDISTORTION2_NUM];
	GLKVector2 _vUniMag;
}

@end

@implementation SimpleDistortion2
- (id)init
{
	self = [super init];
	if (self != nil) {
		memset(&_vUniMag, 0, sizeof(_vUniMag));
	}
	return self;
}
- (GLint) getUniformIndex: (int) index
{
	GLint result = -1;
	//dbgLog(@"%s", __PRETTY_FUNCTION__);
	if ((index >= 0) && (index < (sizeof(_uniforms) / sizeof(_uniforms[0])))) {
		result = _uniforms[index];
	}
	return result;
}

- (BOOL)setupUniforms
{
	BOOL result = NO;
	dbgLog(@"%s", __PRETTY_FUNCTION__);
	@try {
		[self initUniforms];
		// super
		_uniforms[UNI_SIMPLEMULTI_SAMPLERBASE] = glGetUniformLocation(self.programId, "uSamplerBase");
		_uniforms[UNI_SIMPLEMULTI_SAMPLEREFF] = glGetUniformLocation(self.programId, "uSamplerEff");
		
		// mine
		_uniforms[UNI_SIMPLEDISTORTION2_VMAG] = glGetUniformLocation(self.programId, "uVecMag");
		result =YES;
	}
	@catch (NSException *exception) {
		
	}
	return result;
}


- (void)initUniforms
{
	dbgLog(@"%s", __PRETTY_FUNCTION__);
	for (int index = 0; index < (sizeof(_uniforms) / sizeof(_uniforms[0])); index++) {
		_uniforms[index] = -1;
	}
}

- (void)setUniformsOnRenderWithParam:(float)param
{
	float speed = 8.0f;
	_vUniMag.x  = param * speed;
	_vUniMag.y = param * speed;
	glUniform2fv(_uniforms[UNI_SIMPLEDISTORTION2_VMAG], 1, &_vUniMag.x);
}



@end
