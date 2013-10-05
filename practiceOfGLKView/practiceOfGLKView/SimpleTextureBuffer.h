//
//  SimpleTextureBuffer.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 9/17/13.
//  Copyright (c) 2013 nakano_michiharu. All rights reserved.
//

#import "VArrayBase.h"

@interface SimpleTextureBuffer : VArrayBase
@property (readonly, getter = getSizeOfVertex)int sizeOfVertex;
-(BOOL)loadResourceWithName:(NSString*)strNameOfResource;

@end
