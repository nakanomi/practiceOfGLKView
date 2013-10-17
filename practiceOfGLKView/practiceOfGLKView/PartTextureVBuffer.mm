//
//  PartTextureVBuffer.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/9/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "PartTextureVBuffer.h"
#include "gameDefs.h"

static int sNumOfPartTextureVBuffer = 0;

@implementation PartTextureVBuffer

-(id)init
{
	self = [super init];
	if (self != nil) {
		sNumOfPartTextureVBuffer++;
	}
	return self;
}

-(void)setupVerticesByTexPart:(CGRect)rectOfPart withTexSize:(CGSize)sizeTex withRenderTargetSize:(CGSize)sizeOfRender isDebug:(BOOL)isDbg
{
	float sSize = rectOfPart.size.width / sizeTex.width;
	float tSize = rectOfPart.size.height / sizeTex.height;
	float sLeft = rectOfPart.origin.x / sizeTex.width;
	float sRight = sLeft + sSize;
	float tTop = rectOfPart.origin.y / sizeTex.height;
	float tBottom = tTop + tSize;
	float width = rectOfPart.size.width / sizeOfRender.width;
	float height = rectOfPart.size.height / sizeOfRender.height;
	
	[self setParamOfVertex:&_texSquare[0] ofX:-width ofY:height ofZ:0.0f
					   ofS:sLeft ofT:tTop];
	[self setParamOfVertex:&_texSquare[1] ofX:width ofY:height ofZ:0.0f
					   ofS:sRight ofT:tTop];
	[self setParamOfVertex:&_texSquare[2] ofX:-width ofY:-height ofZ:0.0f
					   ofS:sLeft ofT:tBottom];
	[self setParamOfVertex:&_texSquare[3] ofX:width ofY:-height ofZ:0.0f
					   ofS:sRight ofT:tBottom];
	//dbgLog(@"width = %f, height = %f", width, height);
	if (isDbg) {
		int i;
		dbgLog(@"%s", __PRETTY_FUNCTION__);
		for (i = 0; i < 4; i++) {
			dbgLog(@"[%d] : %f\t%f\ts:%f, t:%f", i, _texSquare[i].x, _texSquare[i].y, _texSquare[i].s, _texSquare[i].t);
		}
	}
}

- (void)dealloc
{
	sNumOfPartTextureVBuffer--;
	dbgLog(@"num of PartTextureVBuffer = %d", sNumOfPartTextureVBuffer);
	[super dealloc];
}

@end
