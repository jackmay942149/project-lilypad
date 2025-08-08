#version 330 core

in vec4 v_color;
in vec2 v_coord;

out vec4 o_color;

void main()
{
    o_color = v_color;
}
