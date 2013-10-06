//
//  FboTextureBuffer.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/4/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "VArrayBase.h"
#import "SimpleTextureBuffer.h"


@interface FboTextureBuffer : SimpleTextureBuffer
-(BOOL)loadResourceWithName:(NSString*)strNameOfResource;
-(void)setupForDotByDotRenderSize:(CGSize)sizeRender texSize:(CGSize)sizeTexture;

@end
