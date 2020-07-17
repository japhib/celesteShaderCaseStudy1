uniform vec2 resolution;
uniform vec2 tiling;
uniform vec2 offset;
uniform float time;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    float timestep = step(0, sin(time * 3.14 * 4));

    vec2 uv = texture_coords * tiling + offset;
    vec4 middle = Texel(texture, uv);
    
    vec2 pixelstep = 1 / resolution;
    vec2 uvTop = vec2(uv.x, uv.y + pixelstep.y);
    vec2 uvBot = vec2(uv.x, uv.y - pixelstep.y);
    vec2 uvLeft = vec2(uv.x - pixelstep.x, uv.y);
    vec2 uvRight = vec2(uv.x + pixelstep.x, uv.y);

    vec4 cTop = Texel(texture, uvTop);
    vec4 cBot = Texel(texture, uvBot);
    vec4 cLeft = Texel(texture, uvLeft);
    vec4 cRight = Texel(texture, uvRight);

    vec4 circle = cTop + cBot + cLeft + cRight;
    vec4 outerOnly = clamp(circle, 0.0, 1.0);

    return (middle + timestep * outerOnly) * .9;
}
