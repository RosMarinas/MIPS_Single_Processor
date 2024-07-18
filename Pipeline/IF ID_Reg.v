module IF_ID(
	input wire reset,
	input wire clk,
	input wire[31:0] IF_pc_plus_4,
	input wire[31:0] IF_ins,
	input wire[4:0] stall,
	input wire[4:0]flush,
	output reg[31:0] ID_pc_plus_4,
	output reg[31:0] ID_ins
);
	always@(posedge reset or posedge clk)
	begin
		if(reset)
		begin
			ID_pc_plus_4 <= 32'h0;
			 ID_ins <= 32'h0;
		end
		else
		begin
			if(stall[1])
			begin
				ID_pc_plus_4<=ID_pc_plus_4 ;
				ID_ins <= ID_ins;
			end
			else if(!stall[1]&&stall[0])
			begin
				ID_pc_plus_4 <=32'b0;
				ID_ins <= 32'b0;
			end
            else
            begin
                ID_pc_plus_4 <=IF_pc_plus_4;
				ID_ins <= IF_ins;
            end
			if(flush[0])
			begin
				ID_pc_plus_4 <=32'b0;
				ID_ins <= 32'b0;
			end
		end
	end
endmodule
