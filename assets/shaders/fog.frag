#version 330 core

in vec3  pass_colour;
in vec2  pass_coord;
in vec3  pass_position;
in float pass_depth;

uniform sampler2D uni_texture;

out vec4 out_colour;

void main() {
  float depth = 1 - pow(pass_depth/100, 8);
  vec4 fog_amount = vec4(depth, depth, depth, 1.0f);
  out_colour = fog_amount * texture(uni_texture, pass_coord);
} 
