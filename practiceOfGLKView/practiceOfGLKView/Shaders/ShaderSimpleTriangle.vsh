//
//  Shader.vsh
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/15.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

attribute vec4 position;

varying lowp vec4 colorVarying;

void main()
{
    colorVarying = vec4(1.0, 0.0, 0.0, 1.0);
    
    gl_Position = position;
}
