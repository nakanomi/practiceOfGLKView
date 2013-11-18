//
//  SimpleDistortion.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 11/6/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "SimpleDistortion.h"
#include "gameDefs.h"

enum {
	UNI_SIMPLEDISTORTION_MAG = UNI_SIMPLEMULTI_NUM,
	UNI_SIMPLEDISTORTION_NUM,
};

@interface SimpleDistortion()
{
	GLint _uniforms[UNI_SIMPLEDISTORTION_NUM];
}

@end

@implementation SimpleDistortion
- (id)init
{
	self = [super init];
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
		_uniforms[UNI_SIMPLEDISTORTION_MAG] = glGetUniformLocation(self.programId, "uMag");
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

- (void)setUniformsOnRenderWithParam:(float)param pass:(int)passOfRender;
{
	glUniform1f(_uniforms[UNI_SIMPLEDISTORTION_MAG], param);
}


@end
