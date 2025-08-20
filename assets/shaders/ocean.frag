#version 330 core

in vec4 v_color;
in vec2 v_coord;

out vec4 o_color;

uniform sampler2D u_texture_1;
uniform sampler2D u_texture_2;

void main()
{
    if (v_color.x > 0.5f) {
        o_color = texture(u_texture_1, v_coord);
    } else {
        o_color = texture(u_texture_2, v_coord);
    }
}
