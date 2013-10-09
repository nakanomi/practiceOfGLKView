//
//  PartTextureVBuffer.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/9/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "PartTextureVBuffer.h"

@implementation PartTextureVBuffer

-(void)setupVerticesByTexPart:(CGRect)rectOfPart withTexSize:(CGSize)sizeTex withRenderTargetSize:(CGSize)sizeOfRender
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
}

@end
