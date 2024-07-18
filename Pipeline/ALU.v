
module ALU(
	input [5:0] OpCode,
	input [32 -1:0] in1      , 
	input [32 -1:0] in2      ,
	input [5 -1:0] ALUCtl    ,
	input Sign               ,
	output reg [32 -1:0] out ,
	output  reg  zero
	);
	// zero means whether the output is zero or not

	wire ss;
	assign ss = {in1[31], in2[31]};
	
	wire lt_31;
	assign lt_31 = (in1[30:0] < in2[30:0]);
	
	// lt_signed means whether (in1 < in2)
	wire lt_signed;
	assign lt_signed = (in1[31] ^ in2[31])? 
		((ss == 2'b01)? 0: 1): lt_31;
	
	// Add your code below (for question 2)
	
	// different ALU operations
	always @(*)
		case (ALUCtl)
			5'b00000: out <= in1 & in2;
			5'b00001: out <= in1 | in2;
			5'b00010: out <= in1 + in2;
			5'b00110: out <= in1 - in2;
			5'b00111: out <= {31'h00000000, Sign? lt_signed: (in1 < in2)};
			5'b01100: out <= ~(in1 | in2);
			5'b01101: out <= in1 ^ in2;
			5'b10000: out <= (in2 << in1[4:0]);
			5'b11000: out <= (in2 >> in1[4:0]);
			5'b11001: out <= ({{32{in2[31]}}, in2} >> in1[4:0]);
			5'b11111:out<= in1*in2;
			default: out <= 32'h00000000;
		endcase
	always @(*)
	case(OpCode)
	6'b000101:zero<=out!=0;
	6'b000110:zero<=out<=0;
	6'b000111:zero<=out>0;
	6'b000001:zero<=out<0;
	6'b000100:zero<=out==0;
			default: zero <= 0;
			endcase
	// Add your code above (for question 2)
	
endmodule