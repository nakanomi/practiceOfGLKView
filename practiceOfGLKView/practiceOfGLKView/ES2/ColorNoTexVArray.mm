//
//  ColorNoTexVArray.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/22/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "ColorNoTexVArray.h"
#include "gameDefs.h"

enum {
	_ATTR_COLORNOTEX_POSITION = 0,
};

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
	posCenter.x /= (sizeOfRender.width / 2.0f);
	posCenter.y /= (sizeOfRender.height / 2.0f);
	
	*pMatrix = GLKMatrix4Identity;
	*pMatrix = GLKMatrix4Scale(GLKMatrix4Identity, sizeScale.width, sizeScale.height, 1.0f);
	pMatrix->m30 = posCenter.x;
	pMatrix->m31 = posCenter.y;
	
	//
	//*pMatrix = GLKMatrix4Identity;
}

-(BOOL)loadResourceWithName:(NSString*)strNameOfResource
{
	BOOL result = NO;
	@try {
		const int vertexSize = 12;
		// 構造体サイズが20バイトでない場合はこのコードを使えません
		assert((sizeof(_squarePos[0]) == vertexSize));
		glGenVertexArraysOES(1, &_vertexArray);
		glBindVertexArrayOES(_vertexArray);
		{
			for (int indexVet = 0; indexVet < _NOTEX_NUM_VERTICES; indexVet++) {
				//dbgLog(@"[%d] x:%f,  y:%f,  z:%f", indexVet, _texSquare[indexVet].x, _texSquare[indexVet].y, _texSquare[indexVet].z);
				//dbgLog(@"[%d] s:%f, t:%f", indexVet, _texSquare[indexVet].s, _texSquare[indexVet].t);
			}
			glGenBuffers(1, &_vertexBuffer);
			glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(_squarePos), _squarePos, GL_DYNAMIC_DRAW);
			glEnableVertexAttribArray(_ATTR_COLORNOTEX_POSITION);
			glVertexAttribPointer(_ATTR_COLORNOTEX_POSITION, 3, GL_FLOAT, GL_FALSE, vertexSize, BUFFER_OFFSET(0));
			
		}
		glBindVertexArrayOES(0);
		
		_count = _NOTEX_NUM_VERTICES;
	}
	@catch (NSException *exception) {
		assert(false);
	}
	return result;
}


@end
