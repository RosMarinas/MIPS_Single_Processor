module EX_MEM(
    input reset,
    input clk,
    input [4:0]stall,
    input [31:0] OP2_in,
    input [31:0]pc_in,
    input [31:0]ALURes_in,
    input [4:0] Rt_in,
    input [4:0]RegWr_adin,
    input MemWrite_in,
    input MemRead_in,
    input RegWrite_in, 
    input [1:0]MemtoReg_in,
    output reg [31:0]OP2_out,
    output reg [31:0]ALURes_out,
    output reg [4:0] Rt_out,
    output reg [4:0]RegWr_adout,
    output reg MemWrite_out,
    output reg MemRead_out,
    output reg RegWrite_out,
    output reg [1:0]Mem2Reg_out,
    output reg[31:0]pc_out
);
always@(posedge reset or posedge clk)
	begin
		if(reset)
		begin
		    OP2_out<=0;
            ALURes_out<=0;
            Rt_out<=0;
            RegWr_adout<=0;
            MemWrite_out<=0;
            MemRead_out<=0;
            RegWrite_out<=0;
            Mem2Reg_out<=0;
            pc_out<=0;
		end
		else
		begin
			if(stall[3])
			begin
			OP2_out<=OP2_out;
            ALURes_out<= ALURes_out;
            Rt_out<= Rt_out;
            RegWr_adout<=RegWr_adout;
            MemWrite_out<=MemWrite_out;
            MemRead_out<= MemRead_out;
            RegWrite_out<=RegWrite_out;
            Mem2Reg_out<=Mem2Reg_out;
            pc_out<=pc_out;
			end
			else if(!stall[3]&&stall[2])
			begin
			OP2_out<=0;
            ALURes_out<=0;
            Rt_out<=0;
            RegWr_adout<=0;
            MemWrite_out<=0;
            MemRead_out<=0;
            RegWrite_out<=0;
            Mem2Reg_out<=0;
            pc_out<=0;
			end
            else
            begin
            OP2_out<=OP2_in;
            ALURes_out<= ALURes_in;
            Rt_out<= Rt_in;
            RegWr_adout<=RegWr_adin;
            MemWrite_out<=MemWrite_in;
            MemRead_out<= MemRead_in;
            RegWrite_out<=RegWrite_in;
            Mem2Reg_out<=MemtoReg_in;
            pc_out<=pc_in;
            end
		end
	end
endmodule