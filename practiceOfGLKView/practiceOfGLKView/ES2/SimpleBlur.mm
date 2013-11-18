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

#define _WEIGHT_TABLE_NUM	10
@interface SimpleBlur()
{
	GLint _uniforms[UNI_SIMPLEMULTI_NUM];
	float _weight[_WEIGHT_TABLE_NUM];
}
- (void)makeWeightBySigma:(float)sigma andMu:(float)mu;
@end

@implementation SimpleBlur

- (id)init
{
	self = [super init];
	if (self != nil) {
		_textureCount = 2;
		[self makeWeightBySigma:1.0f andMu:0.0f];
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
		_uniforms[UNI_SIMPLEMULTI_SAMPLERBASE] = glGetUniformLocation(self.programId, "uSamplerBase");
		_uniforms[UNI_SIMPLEMULTI_SAMPLEREFF] = glGetUniformLocation(self.programId, "uSamplerEff");
		result =YES;
	}
	@catch (NSException *exception) {
		
	}
	return result;
}

- (void)initUniforms
{
	for (int index = 0; index < (sizeof(_uniforms) / sizeof(_uniforms[0])); index++) {
		_uniforms[index] = -1;
	}
}
- (void)setUniformsOnRenderWithParam:(float)param pass:(int)passOfRender
{
	// dbgLog(@"%s:%f:%d", __PRETTY_FUNCTION__, param, passOfRender);
}

- (void)makeWeightBySigma:(float)sigma andMu:(float)mu
{
	float leftV = 2.0f * M_PI;
	leftV = sqrtf(leftV);
	leftV *= sigma;
	leftV = 1.0f / leftV;
	assert(sigma >= 1.0f / 65536.0f);
	float sigma2 = sigma * sigma;
	float test = 0.0f;
	for (int i = 0; i < _WEIGHT_TABLE_NUM; i++) {
		float fI = (float)i;
		float rightV = fI - mu;
		rightV *= rightV;
		rightV /= 2.0f * sigma2;
		rightV = 0.0f - rightV;
		rightV = expf(rightV);
		
		_weight[i] = leftV * rightV;
		test += _weight[i];
		//dbgLog(@"[%d]:%f", i, _weight[i]);
	}
	for (int i = 1; i < _WEIGHT_TABLE_NUM; i++) {
		test += _weight[i];
	}
	//dbgLog(@"test:%f", test);
}


@end