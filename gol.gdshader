shader_type canvas_item;

uniform float width;
uniform float height;
uniform float[256] vals;

void fragment() {
	vec2 coord = vec2(floor(UV.x*width),floor(UV.y*height));
	float val = float(vals[int(coord.x + coord.y * width)]);
	COLOR.rgb = vec3(val*0.5 + 0.5);
}