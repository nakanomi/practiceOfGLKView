//
//  SimpleTriangleShader.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/17/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "SimpleTriangleShader.h"

@interface SimpleTriangleShader()
{
	
}
- (BOOL)setupAttributes;

@end

@implementation SimpleTriangleShader
- (BOOL)setupAttributes
{
	BOOL result = NO;
	@try {
		glBindAttribLocation(self.programId, ATTRIB_SIMPLE_TR_POSITION, "position");
		result =YES;
	}
	@catch (NSException *exception) {
	}
	return result;
}


@end
