#version 450 core

layout ( location = 0 ) in	vec2 aPos;
layout ( location = 0 ) out	vec2 vPos;

void main () {
	vec4 pos	= vec4 ( aPos, 0.0, 1.0 );
    vPos		= pos.xy;
    gl_Position	= pos;
}
