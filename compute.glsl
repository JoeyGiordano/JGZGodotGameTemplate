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
	
	float c1 = field1in.data[c];
	float l1 = field1in.data[l];
	float r1 = field1in.data[r];
	float u1 = field1in.data[u];
	float d1 = field1in.data[d];
	float lu1 = field1in.data[lu];
	float ld1 = field1in.data[ld];
	float ru1 = field1in.data[ru];
	float rd1 = field1in.data[rd];
	
	float c2 = field2in.data[c];
	float l2 = field2in.data[l];
	float r2 = field2in.data[r];
	float u2 = field2in.data[u];
	float d2 = field2in.data[d];
	float lu2 = field2in.data[lu];
	float ld2 = field2in.data[ld];
	float ru2 = field2in.data[ru];
	float rd2 = field2in.data[rd];
	
	float dispersion1 = 0.1;
	float dispersion2 = 0.1;
	float loss1 = 0.00;
	float loss2 = 0.00;

	float recieved1 = l1 + r1 + u1 + d1 + lu1 + ld1 + ru1 + rd1;
	recieved1 *= dispersion1 / 8;
	
	float retained1 = (1 - dispersion1 - loss1) * c1;

	float recieved2 = l2 + r2 + u2 + d2 + lu2 + ld2 + ru2 + rd2;
	recieved2 *= dispersion2 / 8;
	
	float retained2 = (1 - dispersion2 - loss2) * c2;

	float chasefact1 = .2;
	float chase1 = 0;
	if (c2-l2 > 0 ) chase1 -= min(1,(c2-l2)) * c1 * chasefact1;
	if (c2-r2 < 0 ) chase1 += min(1,(r2-c2)) * r1 * chasefact1;
	if (c2-r2 > 0 ) chase1 -= min(1,(c2-r2)) * c1 * chasefact1;
	if (c2-l2 < 0 ) chase1 += min(1,(l2-c2)) * l1 * chasefact1;
	if (c2-u2 > 0 ) chase1 -= min(1,(c2-u2)) * c1 * chasefact1;
	if (c2-d2 < 0 ) chase1 += min(1,(d2-c2)) * d1 * chasefact1;
	if (c2-d2 > 0 ) chase1 -= min(1,(c2-d2)) * c1 * chasefact1;
	if (c2-u2 < 0 ) chase1 += min(1,(u2-c2)) * u1 * chasefact1;
	
	float chasefact2 = .2;
	float chase2 = 0;
	if (c1-l1 > 0 ) chase2 -= min(1,(c1-l1)) * c2 * chasefact2;
	if (c1-r1 < 0 ) chase2 += min(1,(r1-c1)) * r2 * chasefact2;
	if (c1-r1 > 0 ) chase2 -= min(1,(c1-r1)) * c2 * chasefact2;
	if (c1-l1 < 0 ) chase2 += min(1,(l1-c1)) * l2 * chasefact2;
	if (c1-u1 > 0 ) chase2 -= min(1,(c1-u1)) * c2 * chasefact2;
	if (c1-d1 < 0 ) chase2 += min(1,(d1-c1)) * d2 * chasefact2;
	if (c1-d1 > 0 ) chase2 -= min(1,(c1-d1)) * c2 * chasefact2;
	if (c1-u1 < 0 ) chase2 += min(1,(u1-c1)) * u2 * chasefact2;

	field1out.data[c] = retained1 + recieved1 + chase1;// - 0.15*c2;
	field2out.data[c] = retained2 + recieved2 + chase2;// + 0.15*c1;//abs(float(x)/float(width) - 0.5) + abs(float(y)/float(height) - 0.5);

}
