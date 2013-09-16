//
//  VArrayBase.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/16.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VArrayBase : NSObject
{
	GLuint _vertexArray;
	GLuint _vertexBuffer;
}
@property (readonly) GLuint vertexArray;

-(id)init;
-(BOOL)loadResourceWithName:(NSString*)strNameOfResource;

@end
