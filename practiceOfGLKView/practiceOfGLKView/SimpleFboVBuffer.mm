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
	// FBOへレンダリングすると上下が逆になるようだ(opengl fbo upside downなどで検索)。それを考慮しt座標を逆の値にする
	[self setParamOfVertex:&_texSquare[0] ofX:-width ofY:height ofZ:0.0f
					   ofS:0.0f ofT:1.0f];
	
	[self setParamOfVertex:&_texSquare[1] ofX:width ofY:height ofZ:0.0f
					   ofS:1.0f ofT:1.0f];
	
	[self setParamOfVertex:&_texSquare[2] ofX:-width ofY:-height ofZ:0.0f
					   ofS:0.0f ofT:0.0f];
	
	[self setParamOfVertex:&_texSquare[3] ofX:width ofY:-height ofZ:0.0f
					   ofS:1.0f ofT:0.0f];
}
// rectRender, rectFboともに左上原点、右と下に向かってXYが増加する
- (void)setupPartFboWithSize:(CGSize)sizeFbo withRenderTarget:(CGSize)sizeRenderTarget withRenderPart:(CGRect)rectRender withFboPart:(CGRect)rectFbo
{
	CGSize sizeST, sizeXY;
	sizeST.width = rectFbo.size.width / sizeFbo.width;
	sizeST.height = rectFbo.size.height / sizeFbo.height;
	sizeXY.width = rectRender.size.width / sizeRenderTarget.width;
	sizeXY.height = rectRender.size.height / sizeRenderTarget.height;
	sizeXY.width *= 2.0f;
	sizeXY.height *= 2.0f;
	
	CGPoint leftTopST;
	leftTopST.x = rectFbo.origin.x / sizeFbo.width;
	leftTopST.y = rectFbo.origin.y / sizeFbo.height;
	CGPoint leftTopXY;
	// 左上が原点サイズ(1,1)での座標
	leftTopXY.x = rectRender.origin.x / sizeRenderTarget.width;
	leftTopXY.y = rectRender.origin.y / sizeRenderTarget.height;
	// 中心が原点サイズ(1,1)での座標
	
	leftTopXY.x -= 0.5f;
	leftTopXY.y -= 0.5f;
	// yを逆方向
	leftTopXY.y = 0 - leftTopXY.y;
	// サイズを(2,2)
	leftTopXY.x *= 2.0f;
	leftTopXY.y *= 2.0f;
	
	
	CGPoint bottomRightXY;
	bottomRightXY.x = leftTopXY.x + sizeXY.width;
	bottomRightXY.y = leftTopXY.y - sizeXY.height;
	
	// FBOではTの方向が逆
	leftTopST.y = 1.0f - leftTopST.y;
	[self setParamOfVertex:&_texSquare[0] ofX:leftTopXY.x ofY:leftTopXY.y ofZ:0.0f
					   ofS:leftTopST.x ofT:leftTopST.y];
	[self setParamOfVertex:&_texSquare[1] ofX:bottomRightXY.x ofY:leftTopXY.y ofZ:0.0f
					   ofS:leftTopST.x + sizeST.width ofT:leftTopST.y];
	[self setParamOfVertex:&_texSquare[2] ofX:leftTopXY.x ofY:bottomRightXY.y ofZ:0.0f
					   ofS:leftTopST.x
						// FBOではTの方向が逆なのでマイナス
					   ofT:leftTopST.y - sizeST.height];
	[self setParamOfVertex:&_texSquare[3] ofX:bottomRightXY.x ofY:bottomRightXY.y ofZ:0.0f
					   ofS:leftTopST.x + sizeST.width
						// FBOではTの方向が逆なのでマイナス
					   ofT:leftTopST.y - sizeST.height];
}


@end
