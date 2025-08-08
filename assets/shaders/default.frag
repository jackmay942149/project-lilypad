#version 330 core

in vec4 v_color;
in vec2 v_coord;

out vec4 o_color;

uniform sampler2D u_texture;

void main()
{
    o_color = texture(u_texture, v_coord) * v_color;
}
