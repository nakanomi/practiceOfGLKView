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

enum {
	_VERTEX_ATTRIB_POSITION = 0,
	_VERTEX_ATTRIB_TEXCOORD,
};


@implementation SimpleTextureBuffer

-(BOOL)loadResourceWithName:(NSString*)strNameOfResource
{
	BOOL result = NO;
	@try {
		glGenVertexArraysOES(1, &_vertexArray);
		glBindVertexArrayOES(_vertexArray);
		{
			glGenBuffers(1, &_vertexBuffer);
			glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(sTexSquare), sTexSquare, GL_STATIC_DRAW);
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

@end
