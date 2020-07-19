uniform vec2 resolution;
uniform vec2 tiling;
uniform vec2 offset;
uniform float time;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    float scaledTime = time * 3.14 * 2;
    float timestep1 = step(-.7, sin(scaledTime));
    float timestep2 = step(.7, sin(scaledTime));

    vec2 uv = texture_coords * tiling + offset;
    vec4 middle = Texel(texture, uv);

    vec2 pixelstep = 1 / resolution;

    // -- inner cross    
    vec2 uvTop = vec2(uv.x, uv.y + pixelstep.y);
    vec2 uvBot = vec2(uv.x, uv.y - pixelstep.y);
    vec2 uvLeft = vec2(uv.x - pixelstep.x, uv.y);
    vec2 uvRight = vec2(uv.x + pixelstep.x, uv.y);

    vec4 cTop = Texel(texture, uvTop);
    vec4 cBot = Texel(texture, uvBot);
    vec4 cLeft = Texel(texture, uvLeft);
    vec4 cRight = Texel(texture, uvRight);

    vec4 cross = cTop + cBot + cLeft + cRight;

    // -- outer diamond
    vec2 uvTop2 = vec2(uv.x, uv.y + pixelstep.y * 2.0);
    vec2 uvBot2 = vec2(uv.x, uv.y - pixelstep.y * 2.0);
    vec2 uvLeft2 = vec2(uv.x - pixelstep.x * 2.0, uv.y);
    vec2 uvRight2 = vec2(uv.x + pixelstep.x * 2.0, uv.y);
    vec2 uvTopRight = vec2(uv.x + pixelstep.x, uv.y + pixelstep.y);
    vec2 uvTopLeft = vec2(uv.x - pixelstep.x, uv.y + pixelstep.y);
    vec2 uvBottomRight = vec2(uv.x + pixelstep.x, uv.y - pixelstep.y);
    vec2 uvBottomLeft = vec2(uv.x - pixelstep.x, uv.y - pixelstep.y);

    vec4 cTop2 = Texel(texture, uvTop2);
    vec4 cBot2 = Texel(texture, uvBot2);
    vec4 cLeft2 = Texel(texture, uvLeft2);
    vec4 cRight2 = Texel(texture, uvRight2);
    vec4 cTopRight = Texel(texture, uvTopRight);
    vec4 cTopLeft = Texel(texture, uvTopLeft);
    vec4 cBottomRight = Texel(texture, uvBottomRight);
    vec4 cBottomLeft = Texel(texture, uvBottomLeft);

    vec4 diamond = cTop2 + cBot2 + cLeft2 + cRight2 + cTopRight + cTopLeft + cBottomRight + cBottomLeft;
    vec4 diamondOnly = clamp(diamond - middle, -1.0, 1.0);

    return middle + timestep1 * cross + timestep2 * diamondOnly;
}
