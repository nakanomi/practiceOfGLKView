//
//  FboBase.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/10/05.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import "FboBase.h"
#import "SimpleFboShader.h"
#import "FboTextureBuffer.h"
@interface FboBase()
{
	GLint _width;
	GLint _height;
	SimpleFboShader* _fboShader;
	FboTextureBuffer* _fboVArray;

	GLuint _fboHandle;
	GLuint _fboTexId;
	GLuint _fboDepthBuffer;
}
@end


@implementation FboBase
@synthesize width = _width;
@synthesize height = _height;

-(id)init
{
	self = [super init];
	if (self != nil) {
		
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}


@end
