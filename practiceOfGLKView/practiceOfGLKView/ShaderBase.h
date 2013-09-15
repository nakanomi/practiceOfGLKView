//
//  ShaderBase.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/15.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface ShaderBase : NSObject
{
}
@property (readonly) GLuint programId;

- (id)init;

- (BOOL)loadShaderWithVsh: (NSString*)vshFile withFsh:(NSString*)fshFile;

- (GLint) getUniformIndex: (int) index;

@end
