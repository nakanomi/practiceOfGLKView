//
//  SimpleFboVBuffer.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/8/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "SimpleTextureVBuffer.h"

@interface SimpleFboVBuffer : SimpleTextureVBuffer

- (void)setupPartFboWithSize:(CGSize)sizeFbo withRenderTarget:(CGSize)sizeRenderTarget withRenderPart:(CGRect)rectRender withFboPart:(CGRect)rectFbo;

@end
