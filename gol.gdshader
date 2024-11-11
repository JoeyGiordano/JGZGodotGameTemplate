shader_type canvas_item;

uniform int[16] vals;
uniform float width = 4.;
uniform float height = 4.;

void fragment() {
	//vals = {0,1,0,1, 0,0,0,1, 0,1,1,1, 1,0,1,1};
	vec2 coord = vec2(floor(UV.x*width),floor(UV.y*height));
	COLOR.rgb = vec3(float(vals[int(coord.x + coord.y * width)]));
}