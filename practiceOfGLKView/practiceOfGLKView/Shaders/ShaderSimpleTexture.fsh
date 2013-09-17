//
//  Shader.fsh
//  practiceOfGLKView
//
//  Created by nakano_michiharu on 2013/09/15.
//  Copyright (c) 2013年 nakano_michiharu. All rights reserved.
//
uniform sampler2D uSampler;
varying mediump vec2 vTexcoord;

void main()
{
    gl_FragColor = texture2D(uSampler, vTexcoord);
}
