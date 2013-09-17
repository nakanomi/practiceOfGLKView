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
	mediump vec4 color = texture2D(uSampler, vTexcoord);
	color.a *= 0.5;
    gl_FragColor = color;
}
