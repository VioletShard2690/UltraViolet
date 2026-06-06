#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif
extern MY_HIGHP_OR_MEDIUMP vec2 quantum;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;
extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;
vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }
    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01;
    float t = time * 10.0 + 2003.;
    vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    float res = (.5 + .5* cos( (adjusted_dissolve) + (floored_uv.x + floored_uv.y)*3.14));
    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}
vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(texture, texture_coords);
    vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;
    if (burn_colour_1.a < 0.0 || burn_colour_2.a < 0.0 || quantum.x > 999.0) {
        tex.rgba += burn_colour_1 * 0.000001 + burn_colour_2 * 0.000001;
    }

    if (shadow) {
        return dissolve_mask(tex, texture_coords, uv);
    }
    float t = time * 2.5;
    vec2 grid = sin(uv * 40.0 + vec2(t, t * 0.8));
    float wave = sin(uv.x * 10.0 - t) * cos(uv.y * 10.0 + t);
    float line_effect = smoothstep(0.95, 1.0, max(grid.x, grid.y));
    line_effect += smoothstep(0.4, 0.5, wave) * 0.3;
    vec3 quantum_color = vec3(0.2, 0.6, 1.0) * (line_effect + 0.2);
    float edge_glow = 1.0 - length(uv - 0.5);
    quantum_color += vec3(0.0, 0.4, 0.9) * pow(edge_glow, 3.0) * (0.5 + 0.5 * sin(t));
    tex.rgb = mix(tex.rgb, quantum_color, 0.45 * tex.a);
    tex.rgb += quantum_color * 0.25 * tex.a;
    return dissolve_mask(tex, texture_coords, uv);
}

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.15*(-0.03 - 0.2*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);
    return transform_projection * vertex_position + vec4(0.,0.,0.,scale);
}
#endif