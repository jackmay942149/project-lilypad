#version 330 core

layout(location = 0) in vec3 a_pos;
layout(location = 1) in vec4 a_color;

out vec4 v_color;

uniform vec2 u_pos;

void main()
{
    gl_Position = vec4(a_pos.xy + u_pos.xy, a_pos.z, 1.0);
    v_color     = a_color;
}
