//
//  SimpleDitortionByPower.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/11/17.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import "SimpleDitortionByPower.h"
#include "gameDefs.h"

enum {
	_UNI_SIMPLEDISTORTIONBYPOW_RADIUS = UNI_SIMPLEMULTI_NUM,
	_UNI_SIMPLEDISTORTIONBYPOW_POWVAL,
	_UNI_SIMPLEDISTORTIONBYPOW_CENTER,
	_UNI_SIMPLEDISTORTIONBYPOW_NUM,
};
@interface SimpleDitortionByPower()
{
	GLint _uniforms[_UNI_SIMPLEDISTORTIONBYPOW_NUM];
	GLKVector2 _posCenter;
}
- (void)initUniforms;
@end

@implementation SimpleDitortionByPower


- (id)init
{
	self = [super init];
	if (self != nil) {
		memset(&_posCenter, 0, sizeof(_posCenter));
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
		_uniforms[_UNI_SIMPLEDISTORTIONBYPOW_RADIUS] = glGetUniformLocation(self.programId, "radius");
		_uniforms[_UNI_SIMPLEDISTORTIONBYPOW_POWVAL] = glGetUniformLocation(self.programId, "powVal");
		
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
	// 71.0:テクスチャの半径 128.0:FBOの半分
	glUniform1f(_uniforms[_UNI_SIMPLEDISTORTIONBYPOW_RADIUS], 71.0f / 128.0f);
	glUniform1f(_uniforms[_UNI_SIMPLEDISTORTIONBYPOW_POWVAL], param);
}


@end
