//
//  TextureBase.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/18/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "TextureBase.h"

@interface TextureBase()
{
	GLuint _textureId;
	CGSize _textureSize;
}
@end

@implementation TextureBase
@synthesize textureId = _textureId;
@synthesize textureSize = _textureSize;


- (id)init
{
	self = [super init];
	if (self != nil) {
		
	}
	return self;
}

@end
