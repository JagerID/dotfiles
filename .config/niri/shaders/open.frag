uniform vec2 u_resolution;
uniform float u_time;

void main () {
  vec2 st = gl_FragCoord.xy / u_resolution;
  gl_FragColor = vec4 ( 1.0, 0.0, 1.0, 1.0 );
}
