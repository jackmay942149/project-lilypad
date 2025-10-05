#version 330 core

in vec3 pass_colour;
in vec2 pass_coord;
in vec3 pass_normal;

uniform sampler2D uni_texture;

out vec4 out_colour;

void main() {
  out_colour = vec4(pass_normal, 1.0f);
} 
