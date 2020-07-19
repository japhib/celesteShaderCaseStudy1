uniform float time;
uniform vec2 size;
uniform float borderSize;

float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p){
	vec2 ip = floor(p);
	vec2 u = fract(p);
	u = u*u*(3.0-2.0*u);
	
	float res = mix(
		mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
	return res*res;
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec2 pixelSize = 1 / size;

    float left = 1 - step(pixelSize.x * borderSize, texture_coords.x);
    float right = step(1 - pixelSize.x * borderSize, texture_coords.x);
    float bottom = 1 - step(pixelSize.y * borderSize, texture_coords.y);
    float top = step(1 - pixelSize.y * borderSize, texture_coords.y);
    float multiplier = clamp(left + right + top + bottom, 0, 1);

    float n1 = noise(screen_coords * .03 + vec2(time, 0));
    float n2 = noise(screen_coords * .03 + vec2(-time, 0) + 200);
    float n3 = noise(screen_coords * .03 + vec2(0, -time) + 400);
    float n4 = noise(screen_coords * .03 + vec2(0, time) + 600);
    float n = (n1 + n2 + n3 + n4) / 4 * .04;

    vec4 unwaved = Texel(texture, texture_coords);

    vec2 waved_coords = vec2(texture_coords.x + n, texture_coords.y + n);
    vec4 waved = Texel(texture, waved_coords);

    return mix(unwaved, waved, multiplier);
}