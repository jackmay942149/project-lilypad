#version 330 core

in vec2 v_coord;

out vec4 o_color;

void main()
{
  o_color = vec4(v_coord, 0.0f, 1.0f);  
}
