//
//  SimpleTriangleBuffer.m
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/17/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "SimpleTriangleBuffer.h"


static GLfloat sTriangleVertexData[9] =
{
	0.0f, 1.0f, 0.0f,
	-1.0f,-1.0f,0.0f,
	1.0f, -1.0f, 0.0f,
};

enum {
	_VERTEX_ATTRIB_POSITION = 0,
};

@implementation SimpleTriangleBuffer
-(BOOL)loadResourceWithName:(NSString*)strNameOfResource
{
	BOOL result = NO;
	@try {
		glGenVertexArraysOES(1, &_vertexArray);
		glBindVertexArrayOES(_vertexArray);
		{
			glGenBuffers(1, &_vertexBuffer);
			glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(sTriangleVertexData), sTriangleVertexData, GL_STATIC_DRAW);
			glEnableVertexAttribArray(_VERTEX_ATTRIB_POSITION);
			glVertexAttribPointer(_VERTEX_ATTRIB_POSITION, 3, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
		}
		glBindVertexArrayOES(0);
		
		_count = 3;
	}
	@catch (NSException *exception) {
	}
	return result;
}


@end
