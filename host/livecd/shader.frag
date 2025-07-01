precision lowp float;

#define SCALAR 0.3

varying vec2 v_texcoord;
uniform sampler2D tex;
const vec3 color = vec3(0.9607, 0.5686, 0.3176); // orange

void main() {
  vec4 pixel = texture2D(tex, v_texcoord);
  pixel.rgb += SCALAR * (color - pixel.rgb);
  gl_FragColor = pixel;
}
