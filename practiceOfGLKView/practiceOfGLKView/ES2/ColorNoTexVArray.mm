//
//  ColorNoTexVArray.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/22/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "ColorNoTexVArray.h"
#include "gameDefs.h"

@implementation ColorNoTexVArray
- (id)init
{
	self = [super init];
	if (self != nil) {
		memset(&_squarePos, 0, sizeof(_squarePos));
		// (-1, -1)から(1,1)までの正方形
		[self setParamOfVertex:&_squarePos[0] ofX:-1.0f ofY: 1.0f ofZ:0.0f];
		[self setParamOfVertex:&_squarePos[1] ofX: 1.0f ofY: 1.0f ofZ:0.0f];
		[self setParamOfVertex:&_squarePos[2] ofX:-1.0f ofY:-1.0f ofZ:0.0f];
		[self setParamOfVertex:&_squarePos[3] ofX: 1.0f ofY:-1.0f ofZ:0.0f];
	}
	return self;
}

-(void)setParamOfVertex:(NOTEX_VERTEX*)vertex ofX:(float)x ofY:(float)y ofZ:(float)z
{
	vertex->x = x;
	vertex->y = y;
	vertex->z = z;
}
-(void)setupMatrixByRectangle:(CGRect)rect withRenderTargetSize:(CGSize)sizeOfRender matrix:(GLKMatrix4*)pMatrix isDebug:(BOOL)isDbg;
{
	CGSize sizeScale = CGSizeMake(rect.size.width / sizeOfRender.width, rect.size.height / sizeOfRender.height);
	dbgLog(@"scale width = %f, height = %f", sizeScale.width, sizeScale.height);
	CGPoint posCenter = CGPointMake((rect.origin.x + (rect.size.width / 2.0f)),
									 (rect.origin.y + (rect.size.height / 2.0f))
									);
	posCenter.x -= (sizeOfRender.width / 2.0f);
	posCenter.y -= (sizeOfRender.height / 2.0f);
	posCenter.y *= -1.0f;
	posCenter.x /= sizeOfRender.width;
	posCenter.y /= sizeOfRender.height;
	
	*pMatrix = GLKMatrix4Identity;
	*pMatrix = GLKMatrix4Scale(GLKMatrix4Identity, sizeScale.width, sizeScale.height, 1.0f);
	pMatrix->m30 = posCenter.x;
	pMatrix->m31 = posCenter.y;
}

@end
