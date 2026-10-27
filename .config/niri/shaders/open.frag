!version 310

uniform	vec2	u_resolution;
uniform	float	u_time;

void main () {
  vec2 uv	= gl_FragCoord.xy / u_resolution;
  uv.x		*= u_resolution.x / u_resolution.y;

  vec3 colorA	= vec3 ( 0.975, 0.235, 0.048 );
  vec3 colorB	= vec3 ( 0.9922, 0.8549, 0.4471 );
  vec3 colorC	= vec3 ( 0.949, 0.835, 0.624 );

  vec3 color	= vec3 ( step ( 0.5, fract ( u_time / 2.0 - uv.x * 5.0 + uv.y * 10.0 ) ) );

  gl_FragColor	= vec4 ( color, 1.0 );
}
