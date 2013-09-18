//
//  TextureBase.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/18/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface TextureBase : NSObject
{
}
@property (readonly)GLuint textureId;
@property (readonly)CGSize textureSize;

- (id)init;
@end
