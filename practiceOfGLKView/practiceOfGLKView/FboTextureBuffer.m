//
//  FboTextureBuffer.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/4/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "FboTextureBuffer.h"

static const int _sizeOfVertex = 5;

enum {
	_VERTEX_ATTRIB_POSITION = 0,
	_VERTEX_ATTRIB_TEXCOORD,
};


@implementation FboTextureBuffer



-(BOOL)loadResourceWithName:(NSString*)strNameOfResource
{
	BOOL result = NO;
	@try {
		{
			CGSize sizeTexture = CGSizeMake(512.0f, 512.0f);
			CGSize sizeRenderBuffer = [VArrayBase getScreenSize];
			[self setupVerticesByTexSize:sizeTexture withRenderBufferSize:sizeRenderBuffer];
		}
		result = [super loadResourceWithName:strNameOfResource];
	}
	@catch (NSException *exception) {
	}
	return result;
}

-(void)setupForDotByDotRenderSize:(CGSize)sizeRender texSize:(CGSize)sizeTexture
{
	
}


@end
