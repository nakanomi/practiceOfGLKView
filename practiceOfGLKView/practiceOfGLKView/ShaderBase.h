//
//  ShaderBase.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/15.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};


@interface ShaderBase : NSObject
{
}
@property (readonly) GLuint programId;

- (id)init;

- (BOOL)loadShaderWithVsh: (NSString*)vshFile withFsh:(NSString*)fshFile;

- (GLint) getUniformIndex: (int) index;

@end
