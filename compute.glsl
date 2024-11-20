#[compute]

#version 450

layout(local_size_x = 16, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) restrict buffer Ints0 {
	int data[];
} dims;

layout(set = 0, binding = 1, std430) restrict buffer Field1in {
	float data[];
} field1in;

layout(set = 0, binding = 2, std430) restrict buffer Field1out {
	float data[];
} field1out;

layout(set = 0, binding = 3, std430) restrict buffer Field2in {
	float data[];
} field2in;

layout(set = 0, binding = 4, std430) restrict buffer Field2out {
	float data[];
} field2out;

void main() {
	int width = dims.data[0];
	int height = dims.data[1];
	
	int x = int(gl_GlobalInvocationID.x % width);
	int y = int(gl_GlobalInvocationID.x / width);

	bool onLeftBorder = x == 0;	
	bool onRightBorder = x == width - 1;
	bool onTopBorder = y == 0;
	bool onBottomBorder = y == height - 1;

	int c = x + y * width;
	
	if (onLeftBorder || onRightBorder || onTopBorder || onBottomBorder) {
		field1out.data[c] = 0;
		field2out.data[c] = 0;
		return;
	}
	
	int l  = x-1 + y * width;
	int r  = x+1 + y * width;
	int u  = x   + (y-1) * width;
	int d  = x   + (y+1) * width;
	int lu = x-1 + (y-1) * width;
	int ld = x-1 + (y+1) * width;
	int ru = x+1 + (y-1) * width;
	int rd = x+1 + (y+1) * width;
	
	float recieved1 = 0.0;
	recieved1 += field1in.data[l] + field1in.data[r] + field1in.data[ru] + field1in.data[d];
	recieved1 += field1in.data[lu] + field1in.data[ld] + field1in.data[rd] + field1in.data[u];
	recieved1 *= 0.1 / 8;
	
	float retained1 = 0.88 * field1in.data[c];

	float recieved2 = 0.0;
	recieved2 += field2in.data[l] + field2in.data[r] + field2in.data[ru] + field2in.data[d];
	recieved2 += field2in.data[lu] + field2in.data[ld] + field2in.data[rd] + field2in.data[u];
	recieved2 *= 0.2 / 8;
	
	float retained2 = 0.88 * field2in.data[c];
	

	field1out.data[c] = retained1 + recieved1 - 0.15*field2in.data[c];
	field2out.data[c] = retained2 + recieved2 + 0.15*field1in.data[c];
}
