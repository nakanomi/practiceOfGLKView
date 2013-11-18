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
	int _textureCount;
}
@property (readonly) GLuint programId;
@property (readonly) int textureCount;

- (id)init;

- (BOOL)loadShaderWithVsh: (NSString*)vshFile withFsh:(NSString*)fshFile;

- (GLint) getUniformIndex: (int) index;
- (void)setUniformsOnRenderWithParam:(float)param pass:(int)passOfRender;


@end
