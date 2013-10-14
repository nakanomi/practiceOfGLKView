//
//  PartTextureVBuffer.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/9/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "SimpleTextureVBuffer.h"

@interface PartTextureVBuffer : SimpleTextureVBuffer
-(id)init;
-(void)setupVerticesByTexPart:(CGRect)rectOfPart withTexSize:(CGSize)sizeTex withRenderTargetSize:(CGSize)sizeOfRender;
@end
