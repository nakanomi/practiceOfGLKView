//
//  SimpleTextureBuffer.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/17/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "SimpleTextureBuffer.h"
/*
static GLfloat sTexSquare[] =
{
	-0.5f, 0.5f, 0.0f,			0.0f, 0.0f,
	0.5f,  0.5f, 0.0f,			1.0f, 0.0f,
	-0.5f,-0.5f, 0.0f,			0.0f, 1.0f,
	0.5f, -0.5f, 0.0f,			1.0f, 1.0f,
};
 */

static SIMPLE_TEXTURE_VERTEX texSquare[4] = {
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

@interface SimpleTextureBuffer()
{
}
@end

@implementation SimpleTextureBuffer

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
			texSquare[0].x = -width;
			texSquare[0].y = height;
			
			texSquare[1].x = width;
			texSquare[1].y = height;
			
			texSquare[2].x = -width;
			texSquare[2].y = -height;
			
			texSquare[3].x = width;
			texSquare[3].y = -height;
		}
		// 構造体サイズが20バイトでない場合はこのコードを使えません
		assert((sizeof(texSquare[0]) == 20));
		glGenVertexArraysOES(1, &_vertexArray);
		glBindVertexArrayOES(_vertexArray);
		{
			glGenBuffers(1, &_vertexBuffer);
			glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(texSquare), texSquare, GL_DYNAMIC_DRAW);
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
