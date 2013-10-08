//
//  FboBase.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/10/05.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FboBase : NSObject
{
	
}
@property (readonly)CGSize sizeFbo;
-(id)init;
- (void)changeRenderTargetToFBO;
- (void)setupFboWithSize:(CGSize)sizeFbo withRenderTarget:(CGSize)sizeRenderTarget;
- (void)render;

+ (void)setDefaultFbo;

@end
