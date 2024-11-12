shader_type canvas_item;

uniform float width;
uniform float height;
uniform int[256] vals;

void fragment() {
	vec2 coord = vec2(floor(UV.x*width),floor(UV.y*height));
	COLOR.rgb = vec3(float(vals[int(coord.x + coord.y * width)]));
}