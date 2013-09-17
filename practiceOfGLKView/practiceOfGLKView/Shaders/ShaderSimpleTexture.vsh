//
//  Shader.vsh
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/15.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//

attribute vec4 position;
attribute vec2 texcoord;

varying vec2 vTexcoord;
uniform vec4 uniTrance;
void main()
{
    gl_Position = position + uniTrance;
    vTexcoord = texcoord;
}
