uniform vec2 tiling;
uniform vec2 offset;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec2 uv = texture_coords * tiling + offset;

    vec4 c = Texel(texture, uv);
    
    return c * .8;
}
