module DataMemory(
	input  reset    , 
	input  clk      ,  
	input  MemRead  ,
	input  MemWrite ,
	input  [32 -1:0] Address    ,
	input  [32 -1:0] Write_data ,
	output [32 -1:0] Read_data,
	output reg [11:0]digi
);
	
	// RAM size is 256 words, each word is 32 bits, valid address is 8 bits
	parameter RAM_SIZE      = 512;
	parameter RAM_SIZE_BIT  = 9;
	
	// RAM_data is an array of 256 32-bit registers
	reg [31:0] RAM_data [RAM_SIZE - 1: 0];

	// read data from RAM_data as Read_data
	assign Read_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	// write Write_data to RAM_data at clock posedge
	integer i;
	always @(posedge reset or posedge clk)
		if (reset)
			begin 
			RAM_data[200] <= 32'h3F; // 4'h0: seg <= ~7'b1000000;
RAM_data[201] <= 32'h06; // 4'h1: seg <= ~7'b1111001;
RAM_data[202] <= 32'h5B; // 4'h2: seg <= ~7'b0100100;
RAM_data[203] <= 32'h4F; // 4'h3: seg <= ~7'b0110000;
RAM_data[204] <= 32'h66; // 4'h4: seg <= ~7'b0011001;
RAM_data[205] <= 32'h6D; // 4'h5: seg <= ~7'b0010010;
RAM_data[206] <= 32'h7D; // 4'h6: seg <= ~7'b0000010;
RAM_data[207] <= 32'h07; // 4'h7: seg <= ~7'b1111000;
RAM_data[208] <= 32'h7F; // 4'h8: seg <= ~7'b0000000;
RAM_data[209] <= 32'h6F; // 4'h9: seg <= ~7'b0010000;
RAM_data[210] <= 32'h77; // 4'ha: seg <= ~7'b0001000;
RAM_data[211] <= 32'h7C; // 4'hb: seg <= ~7'b0000011;
RAM_data[212] <= 32'h39; // 4'hc: seg <= ~7'b1000110;
RAM_data[213] <= 32'h5E; // 4'hd: seg <= ~7'b0100001;
RAM_data[214] <= 32'h79; // 4'he: seg <= ~7'b0000110;
RAM_data[215] <= 32'h71; // 4'hf: seg <= ~7'b0001110;


				for (i = 216; i < RAM_SIZE; i = i + 1)
				begin
					RAM_data[i] <= 32'h00000000;
				end
				for (i=0;i<200;i=i+1)
				begin
					RAM_data[i] <= 32'h00000000;
				end
				digi<=11'b0;
			end 
		else if (MemWrite &&Address!=32'h40000010)
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
		else if (MemWrite && Address==32'h40000010)
		digi<=Write_data[11:0];
endmodule
