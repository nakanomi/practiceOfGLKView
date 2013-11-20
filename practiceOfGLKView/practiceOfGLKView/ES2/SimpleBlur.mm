//
//  SimpleBlur.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/11/18.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import "SimpleBlur.h"
#include "gameDefs.h"
#include <math.h>

#define _WEIGHT_TABLE_NUM	4
enum {
	_UNI_SIMPLEBLUR_WEIGHT = UNI_SIMPLE_TEXTURE_NUM,
	_UNI_SIMPLEBLUR_VDELTA,
	_UNI_SIMPLEBLUR_NUM,
};
@interface SimpleBlur()
{
	GLint _uniforms[_UNI_SIMPLEBLUR_NUM];
	float _weight[_WEIGHT_TABLE_NUM];
	GLKVector2 _vDelta;
}
- (void)makeWeightBySigma:(float)sigma andMu:(float)mu;
@end

@implementation SimpleBlur

- (id)init
{
	self = [super init];
	if (self != nil) {
		_textureCount = 1;
		[self makeWeightBySigma:4.0f andMu:0.0f];
	}
	return self;
}
- (GLint) getUniformIndex: (int) index
{
	GLint result = -1;
	if ((index >= 0) && (index < (sizeof(_uniforms) / sizeof(_uniforms[0])))) {
		result = _uniforms[index];
	}
	return result;
}
- (BOOL)setupUniforms
{
	BOOL result = NO;
	@try {
		[self initUniforms];
		_uniforms[UNI_SIMPLE_TEXTURE_SAMPLER] = glGetUniformLocation(self.programId, "uSamplerBase");
		_uniforms[_UNI_SIMPLEBLUR_WEIGHT] = glGetUniformLocation(self.programId, "uWeight");
		_uniforms[_UNI_SIMPLEBLUR_VDELTA] = glGetUniformLocation(self.programId, "uVDelta");
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
- (void)setUniformsOnRenderWithParam:(float)param pass:(int)passOfRender
{
	
	glUniform1fv(_uniforms[_UNI_SIMPLEBLUR_WEIGHT], _WEIGHT_TABLE_NUM, &_weight[0]);
	float textureDotSize = 1.0f / param;
	if (passOfRender == 0) {
		// 1パス目は横
		_vDelta = GLKVector2Make(textureDotSize, 0.0f);
	}
	else {
		// 2パス目は縦
		_vDelta = GLKVector2Make(0.0f, textureDotSize);
		
	}
	glUniform2fv(_uniforms[_UNI_SIMPLEBLUR_VDELTA], 1, &_vDelta.x);
}

- (void)makeWeightBySigma:(float)sigma andMu:(float)mu
{
	float leftV = 2.0f * M_PI;
	leftV = sqrtf(leftV);
	leftV *= sigma;
	leftV = 1.0f / leftV;
	assert(sigma >= 1.0f / 65536.0f);
	float sigma2 = sigma * sigma;
	float sum = 0.0f;
	for (int i = 0; i < _WEIGHT_TABLE_NUM; i++) {
		float fI = (float)i;
		float rightV = fI - mu;
		rightV *= rightV;
		rightV /= 2.0f * sigma2;
		rightV = 0.0f - rightV;
		rightV = expf(rightV);
		
		_weight[i] = leftV * rightV;
		sum += _weight[i];
		dbgLog(@"[%d]:%f", i, _weight[i]);
	}
	for (int i = 1; i < _WEIGHT_TABLE_NUM; i++) {
		sum += _weight[i];
	}
	dbgLog(@"sum0:%f", sum);
	// sumが１になるようにする
	float denom = 1.0 / sum;
	sum = 0.0f;
	for (int i = 0; i < _WEIGHT_TABLE_NUM; i++) {
		_weight[i] = _weight[i] * denom;
		sum += _weight[i];
	}
	for (int i = 1; i < _WEIGHT_TABLE_NUM; i++) {
		sum += _weight[i];
	}
	dbgLog(@"sum1:%f", sum);
}


@end
