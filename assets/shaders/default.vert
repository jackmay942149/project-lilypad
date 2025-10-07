#version 330 core

layout (location = 0) in vec3 in_pos;
layout (location = 1) in vec3 in_colour;
layout (location = 2) in vec2 in_coord;
layout (location = 3) in vec3 in_normal;

out vec3  pass_position;
out vec3  pass_colour;
out vec2  pass_coord;
out vec3  pass_normal;
out float pass_depth;

uniform mat4 uni_model;
uniform mat4 uni_view;
uniform mat4 uni_projection;

void main() {
  pass_colour = in_colour;
  pass_coord = in_coord;
  pass_normal = in_normal;
  pass_position = in_pos;

  vec4 view_pos = uni_view * uni_model * vec4(in_pos, 1.0f);
  pass_depth = length(view_pos);
  gl_Position = uni_projection * view_pos;
}
