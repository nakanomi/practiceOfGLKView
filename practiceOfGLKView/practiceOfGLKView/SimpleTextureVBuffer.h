//
//  SimpleTextureBuffer.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/17/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "VArrayBase.h"
typedef struct {
	float x, y, z;
	float s, t;
}SIMPLE_TEXTURE_VERTEX;

@interface SimpleTextureVBuffer : VArrayBase

- (id)init;
-(BOOL)loadResourceWithName:(NSString*)strNameOfResource;
-(void)setParamOfVertex:(SIMPLE_TEXTURE_VERTEX*)vertex ofX:(float)x ofY:(float)y
					ofZ:(float)z ofS:(float)s ofT:(float)t;

-(void)setupVerticesByTexSize:(CGSize)sizeTexture withRenderBufferSize:(CGSize)sizeRenderBuf;

@end
