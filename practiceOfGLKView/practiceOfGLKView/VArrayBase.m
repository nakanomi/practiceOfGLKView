//
//  VArrayBase.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/16.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import "VArrayBase.h"

@interface VArrayBase()
{
}

@end

static CGSize sVarrayScreenSize = {0, 0};
@implementation VArrayBase
@synthesize vertexArray = _vertexArray;
@synthesize count = _count;

-(id)init
{
	self = [super init];
	if (self != nil) {
		_vertexArray = 0;
		_vertexBuffer = 0;
		_count = 0;
	}
	return self;
}

- (void)dealloc
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	if (_vertexBuffer != 0) {
		glDeleteBuffers(1, &_vertexBuffer);
	}
	if (_vertexArray != 0) {
		glDeleteVertexArraysOES(1, &_vertexArray);
	}
	[super dealloc];
}

-(BOOL)loadResourceWithName:(NSString*)strNameOfResource
{
	//派生クラスで実装する
	assert(NO);
	return NO;
}


+(CGSize)getScreenSize
{
	if (sVarrayScreenSize.height == 0.0f) {
		assert(NO);
	}
	return sVarrayScreenSize;
}
+(void)setScreenSize:(CGSize)screenSize
{
	sVarrayScreenSize = screenSize;
}

@end
