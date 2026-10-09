#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_mouse;
uniform vec2 u_resolution;

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution;
  gl_FragColor = vec4 ( vec3 ( step ( 0.375, st.x ) - step ( 0.625, st.x ) ), 1.0 );
}
