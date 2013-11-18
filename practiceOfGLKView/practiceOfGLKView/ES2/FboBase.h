//
//  FboBase.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/10/05.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface FboBase : NSObject
{
	GLKVector4 _clearColor;
}
@property (readonly)CGSize sizeFbo;
@property (readwrite)GLKVector4 clearColor;
@property (readonly)GLuint texId;
@property (readonly)GLsizei countVertice;
-(id)init;
- (void)changeRenderTargetToFBO;
- (void)setupFboWithSize:(CGSize)sizeFbo withRenderTarget:(CGSize)sizeRenderTarget;
- (void)setupPartFboWithSize:(CGSize)sizeFbo withRenderTarget:(CGSize)sizeRenderTarget withRenderPart:(CGRect)rectRende withFboPart:(CGRect)rectFbo;
- (void)render;
- (void)bindVertex;

+ (void)setDefaultFbo;

@end
