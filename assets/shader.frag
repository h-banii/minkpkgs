precision lowp float;

#define SCALE 1.25
#define HARD_THRESHOLD false
const vec3 COLOR = vec3(1.0, 0.435, 0.); // orange

varying vec2 v_texcoord;
uniform sampler2D tex;

float max_vec4(vec4 pixel) {
  return max(max(pixel.r, pixel.g), pixel.b);
}

float min_vec4(vec4 pixel) {
  return min(min(pixel.r, pixel.g), pixel.b);
}

vec3 step(vec3 pixel, float scale) {
  return pixel.rgb + (COLOR - pixel.rgb) * scale;
}

vec4 transform(vec4 pixel) {
  float max_cmp = max_vec4(pixel);
  float min_cmp = min_vec4(pixel);

  // Hard threshold
  if (HARD_THRESHOLD && (max_cmp - min_cmp) < 0.1) {
    return pixel;
  }

  // Soft threshold
  float scale = min(SCALE * (max_cmp - min_cmp), 1.0);

  pixel.rgb = step(pixel.rgb, scale);
  pixel.rgb *= max_cmp / max_vec4(pixel);

  return pixel;
}

void main() {
  vec4 pixel = texture2D(tex, v_texcoord);
  gl_FragColor = transform(pixel);
}
