//
//  SimpleFboVBuffer.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/8/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "SimpleFboVBuffer.h"

@implementation SimpleFboVBuffer

-(void)setupVerticesByTexSize:(CGSize)sizeTexture withRenderBufferSize:(CGSize)sizeRenderBuf
{
	float width = sizeTexture.width / sizeRenderBuf.width;
	float height = sizeTexture.height / sizeRenderBuf.height;
	// 頂点座標をテクスチャサイズにあわせる
	[self setParamOfVertex:&_texSquare[0] ofX:-width ofY:height ofZ:0.0f
					   ofS:0.0f ofT:1.0f];
	
	[self setParamOfVertex:&_texSquare[1] ofX:width ofY:height ofZ:0.0f
					   ofS:1.0f ofT:1.0f];
	
	[self setParamOfVertex:&_texSquare[2] ofX:-width ofY:-height ofZ:0.0f
					   ofS:0.0f ofT:0.0f];
	
	[self setParamOfVertex:&_texSquare[3] ofX:width ofY:-height ofZ:0.0f
					   ofS:1.0f ofT:0.0f];
}

@end
