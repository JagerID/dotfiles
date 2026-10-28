#version 450 core

layout ( location = 0 )	uniform	float u_time;
layout ( location = 1 )	in		vec2 pos;

layout ( location = 0 )	out		vec4 fragColor;

void main () {
    fragColor = vec4 ( sin ( u_time ) );
}
