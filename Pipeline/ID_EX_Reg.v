module ID_EX(
     //Input Clock Signals
    input reset,
    input clk,
    input Sign,
    input [4:0]stall,
    input [4:0]flush,
    input [31:0]databus2_in,
    input [31:0]ext_in,
    input [31:0]PC_4_in,
    input [31:0]OP1_in,
    input [31:0]OP2_in,
    input MemWrite_in,
    input MemRead_in,
    input RegWrite_in,
    input [1:0]MemtoReg_in,
    input  [4:0]ALUCtrl_in,
    input ALUsrc1_in,
    input ALUsrc2_in,
    input [4:0] Rs_in,
    input [4:0]Rt_in,
    input [4:0]Rd_in,
    input branch_in,
    input [5:0]Zero_OpCode_in,
    input [1:0] RegDst_in,
    output reg [31:0]PC_4_out,
    output reg [31:0] OP1_out,
    output reg [31:0]OP2_out,
    output reg MemWrite_out,
    output reg MemRead_out,
    output reg RegWrite_out,
    output  reg [1:0]MemtoReg_out,
    output reg [4:0]ALUCtrl_out,
    output reg ALUsrc1_out,
    output  reg ALUsrc2_out,
    output reg [4:0] Rs_out,
    output reg [4:0]Rt_out,
    output reg [4:0]Rd_out,
    output reg branch_out,
    output reg [5:0]Zero_OpCode_out,
    output reg [1:0] RegDst_out,
    output reg  sign_out,
    output reg [31:0]ext_out,
    output reg [31:0]databus2_out
);
always@(posedge reset or posedge clk)
	begin
		if(reset)
		begin
                PC_4_out<=0;
				OP1_out<=0;
                OP2_out<=0;
                MemWrite_out<=0;
                MemRead_out<=0;
                RegWrite_out<=0;
                MemtoReg_out<=0;
                ALUCtrl_out<=0;
                ALUsrc1_out<=0;
                ALUsrc2_out<=0;
                Rs_out<=0;
                Rt_out<=0;
                Rd_out<=0;
                branch_out<=0;
                Zero_OpCode_out<=0;
                RegDst_out<=0;
                sign_out<=0;
                ext_out<=0;
                databus2_out<=0;
		end
		else
		begin
			if(stall[2])
			begin
                PC_4_out<=PC_4_out;
				OP1_out<=OP1_out;
                OP2_out<=OP2_out;
                MemWrite_out<= MemWrite_out;
                MemRead_out<=MemRead_out;
                RegWrite_out<=RegWrite_out;
                MemtoReg_out<= MemtoReg_out;
                ALUCtrl_out<=ALUCtrl_out;
                ALUsrc1_out<=ALUsrc1_out;
                ALUsrc2_out<=ALUsrc2_out;
                Rs_out<=Rs_out;
                Rt_out<=Rt_out;
                Rd_out<=Rd_out;
                branch_out<=branch_out;
                Zero_OpCode_out<=Zero_OpCode_out;
                RegDst_out<=RegDst_out;
                sign_out<=sign_out;
                ext_out<=ext_out;
  databus2_out<=databus2_out;
			end
			else if(!stall[2]&&stall[1])
			begin
                PC_4_out<=0;
				OP1_out<=0;
                OP2_out<=0;
                MemWrite_out<=0;
                MemRead_out<=0;
                RegWrite_out<=0;
                MemtoReg_out<=0;
                ALUCtrl_out<=0;
                ALUsrc1_out<=0;
                ALUsrc2_out<=0;
                Rs_out<=0;
                Rt_out<=0;
                Rd_out<=0;
                branch_out<=0;
                Zero_OpCode_out<=0;
                RegDst_out<=0;
                sign_out<=0;
                ext_out<=0;
                databus2_out<=0;
                			end
            else
            begin
                PC_4_out<=PC_4_in;
                OP1_out<=OP1_in;
                OP2_out<=OP2_in;
                MemWrite_out<= MemWrite_in;
                MemRead_out<=MemRead_in;
                RegWrite_out<=RegWrite_in;
                MemtoReg_out<= MemtoReg_in;
                ALUCtrl_out<=ALUCtrl_in;
                ALUsrc1_out<=ALUsrc1_in;
                ALUsrc2_out<=ALUsrc2_in;
                Rs_out<=Rs_in;
                Rt_out<=Rt_in;
                Rd_out<=Rd_in;
                branch_out<=branch_in;
                Zero_OpCode_out<=Zero_OpCode_in;
                RegDst_out<=RegDst_in;
                sign_out<=Sign;
                ext_out<=ext_in;
databus2_out<=databus2_in;
            end
			if(flush[1])
			begin
				OP1_out<=0;
                OP2_out<=0;
                MemWrite_out<=0;
                MemRead_out<=0;
                RegWrite_out<=0;
                MemtoReg_out<=0;
                ALUCtrl_out<=0;
                ALUsrc1_out<=0;
                ALUsrc2_out<=0;
                Rs_out<=0;
                Rt_out<=0;
                Rd_out<=0;
                branch_out<=0;
                Zero_OpCode_out<=0;
                RegDst_out<=0;
                sign_out<=0;
                ext_out<=0;
databus2_out<=0;
			end
		end
	end
endmodule