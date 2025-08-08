#version 330 core

layout(location = 0) in vec3 a_pos;
layout(location = 1) in vec4 a_color;
layout(location = 2) in vec2 a_coord;

out vec4 v_color;
out vec2 v_coord;

uniform vec2 u_pos;

void main()
{
    gl_Position = vec4(a_pos.xy + u_pos.xy, a_pos.z, 1.0);
    v_color     = a_color;
    v_coord     = a_coord;
}
