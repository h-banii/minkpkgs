#version 300 es

precision lowp float;

#define SCALE 1.25
const vec3 COLOR = vec3(1.0, 0.435, 0.); // orange

out vec4 fragColor;
in vec2 v_texcoord;
uniform sampler2D tex;

float max_vec3(vec3 pixel) {
  return max(max(pixel.r, pixel.g), pixel.b);
}

float min_vec3(vec3 pixel) {
  return min(min(pixel.r, pixel.g), pixel.b);
}

vec3 step(vec3 pixel, float scale) {
  return pixel.rgb + (COLOR - pixel.rgb) * scale;
}

vec4 transform(vec4 pixel) {
  float max_cmp = max_vec3(pixel.rgb);
  float min_cmp = min_vec3(pixel.rgb);

  float scale = min(SCALE * (max_cmp - min_cmp), 1.0);

  pixel.rgb = step(pixel.rgb, scale);
  pixel.rgb *= max_cmp / max_vec3(pixel.rgb);

  return pixel;
}

void main() {
  vec4 pixel = texture(tex, v_texcoord);
  fragColor = transform(pixel);
}
