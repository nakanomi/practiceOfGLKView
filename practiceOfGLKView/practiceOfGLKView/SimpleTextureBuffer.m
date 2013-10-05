//
//  SimpleTextureBuffer.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/17/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "SimpleTextureBuffer.h"

static GLfloat sTexSquare[] =
{
	-0.5f, 0.5f, 0.0f,			0.0f, 0.0f,
	0.5f,  0.5f, 0.0f,			1.0f, 0.0f,
	-0.5f,-0.5f, 0.0f,			0.0f, 1.0f,
	0.5f, -0.5f, 0.0f,			1.0f, 1.0f,
};

#define _SIZE_OF_VERTEX	5

enum {
	_VERTEX_ATTRIB_POSITION = 0,
	_VERTEX_ATTRIB_TEXCOORD,
};


@implementation SimpleTextureBuffer
- (void)setX:(float)valueX ofVertex:(int)indexOfVertex
{
	sTexSquare[self.sizeOfVertex * indexOfVertex] = valueX;
}

- (void)setY:(float)valueY ofVertex:(int)indexOfVertex
{
	sTexSquare[(self.sizeOfVertex * indexOfVertex) + 1] = valueY;
}

-(BOOL)loadResourceWithName:(NSString*)strNameOfResource
{
	BOOL result = NO;
	@try {
		CGSize screenSize = [VArrayBase getScreenSize];
		const float textureSize = 16.0f;
		float width = textureSize / screenSize.width;
		float height = textureSize / screenSize.height;
		{
			// 頂点座標をテクスチャサイズにあわせる
			[self setX:-width ofVertex:0];
			[self setY:height ofVertex:0];
			
			[self setX:width ofVertex:1];
			[self setY:height ofVertex:1];
			
			[self setX:-width ofVertex:2];
			[self setY:-height ofVertex:2];
			[self setX:width ofVertex:3];
			[self setY:-height ofVertex:3];
		}
		glGenVertexArraysOES(1, &_vertexArray);
		glBindVertexArrayOES(_vertexArray);
		{
			glGenBuffers(1, &_vertexBuffer);
			glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(sTexSquare), sTexSquare, GL_DYNAMIC_DRAW);
			glEnableVertexAttribArray(_VERTEX_ATTRIB_POSITION);
			glEnableVertexAttribArray(_VERTEX_ATTRIB_TEXCOORD);
			glVertexAttribPointer(_VERTEX_ATTRIB_POSITION, 3, GL_FLOAT, GL_FALSE, 20, BUFFER_OFFSET(0));
			glVertexAttribPointer(_VERTEX_ATTRIB_TEXCOORD, 2, GL_FLOAT, GL_FALSE, 20, BUFFER_OFFSET(12));
	
		}
		glBindVertexArrayOES(0);
		
		_count = 4;
	}
	@catch (NSException *exception) {
	}
	return result;
}

- (int)getSizeOfVertex
{
	return _SIZE_OF_VERTEX;
}

@end
