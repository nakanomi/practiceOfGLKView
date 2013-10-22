//
//  ColorNoTexVArray.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 10/22/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "VArrayBase.h"

typedef struct {
	float x, y, z;
}NOTEX_VERTEX;

#define _NOTEX_NUM_VERTICES	4

@interface ColorNoTexVArray : VArrayBase
{
	NOTEX_VERTEX _squarePos[_NOTEX_NUM_VERTICES];
}
-(void)setParamOfVertex:(NOTEX_VERTEX*)vertex ofX:(float)x ofY:(float)y ofZ:(float)z;
- (id)init;
-(void)setupMatrixByRectangle:(CGRect)rect withRenderTargetSize:(CGSize)sizeOfRender matrix:(GLKMatrix4*)pMatrix isDebug:(BOOL)isDbg;
-(BOOL)loadResourceWithName:(NSString*)strNameOfResource;

@end
