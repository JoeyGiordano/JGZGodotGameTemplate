#[compute]

#version 450

layout(local_size_x = 16, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) restrict buffer Ints0 {
	int data[];
} dims;

layout(set = 0, binding = 1, std430) restrict buffer Ints1 {
	int data[];
} ints;

layout(set = 0, binding = 2, std430) restrict buffer Ints2 {
	int data[];
} outs;

void main() {
	int width = dims.data[0];
	int height = dims.data[1];
	int sum = 0;
	
	int x = int(gl_GlobalInvocationID.x % width);
	int y = int(gl_GlobalInvocationID.x / width);
	
	int c = x + y * width;
	int l = x-1 + y * width;
	int r = x+1 + y * width;
	int u = x   + (y-1) * width;
	int d = x   + (y+1) * width;
	int lu = x-1+ (y-1) * width;
	int ld = x-1+ (y+1) * width;
	int ru = x+1+ (y-1) * width;
	int rd = x+1+ (y+1) * width;

	bool onLeftBorder = x == 0;	
	bool onRightBorder = x == width - 1;
	bool onTopBorder = y == 0;
	bool onBottomBorder = y == height - 1;

	if (!onLeftBorder) {	//left
		sum += ints.data[l];
		if (!onTopBorder) {	//left up
			sum += ints.data[lu];
		}
		if (!onBottomBorder) {	//left down
			sum += ints.data[ld];
		}
	}
	if (!onRightBorder) {	//right
		sum += ints.data[r];
		if (!onTopBorder) {	//right up
			sum += ints.data[ru];
		}
		if (!onBottomBorder) {	//right down
			sum += ints.data[rd];
		}
	}
	if (!onTopBorder) {	//up
		sum += ints.data[u];
	}
	if (!onBottomBorder) {	//down
		sum += ints.data[d];
	}
	int is_alive = ints.data[c];

	int new_val = 0;
	
	if (sum == 3) {
		new_val = 1;
	}
	else if (sum == 2 && is_alive == 1) {
		new_val = 1;
	}

	outs.data[c] = new_val;
}
