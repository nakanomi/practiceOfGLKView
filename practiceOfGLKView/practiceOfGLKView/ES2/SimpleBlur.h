//
//  SimpleBlur.h
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/11/18.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

#import "SimpleTextureShader.h"

@interface SimpleBlur : SimpleTextureShader
{
	
}
- (id)init;
- (GLint) getUniformIndex: (int) index;

@end
