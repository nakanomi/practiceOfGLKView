//
//  SimpleFboShader.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/4/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "SimpleFboShader.h"
@interface SimpleFboShader()
- (BOOL)setupAttributes;
- (BOOL)setupUniforms;
- (void)initUniforms;
@end


@implementation SimpleFboShader
- (GLint) getUniformIndex: (int) index
{
	int result = -1;
	return result;
}

- (BOOL)setupAttributes
{
	BOOL result = NO;
	@try {
		glBindAttribLocation(self.programId, ATTR_SIMPLE_FBO_POSITION, "position");
		glBindAttribLocation(self.programId, ATTR_SIMPLE_FBO_TEXCOORD, "texcoord");
		result =YES;
	}
	@catch (NSException *exception) {
		
	}
	return result;
}
- (BOOL)setupUniforms
{
	BOOL result = NO;
	@try {
		result =YES;
	}
	@catch (NSException *exception) {
		
	}
	return result;
}
- (void)initUniforms
{
}

@end
