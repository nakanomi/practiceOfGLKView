//
//  VArrayBase.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/16.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface VArrayBase : NSObject
{
	GLuint _vertexArray;
	GLuint _vertexBuffer;
	GLsizei _count;
}
@property (readonly) GLuint vertexArray;
@property (readonly) GLsizei count;

-(id)init;
-(BOOL)loadResourceWithName:(NSString*)strNameOfResource;

@end
