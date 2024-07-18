module MEM_WB(
    input reset,
    input clk,
    input stall,
    input [31:0] ALU_Res_in,
    input [31:0]bus_B_in,
    input [4:0] Rt_in,
    input [4:0]RegWr_adin,
    input MemWrite_in,
    input MemRead_in,
    input RegWrite_in, 
    input [1:0]MemtoReg_in,
    input[31:0]Mem_Res_in, 
    output reg [31:0] ALU_Res_out,
    output reg [31:0]bus_B_out,
    output reg [4:0] Rt_out,
    output reg [4:0]RegWr_adout,
    output reg MemWrite_out,
    output reg MemRead_out,
    output reg RegWrite_out,
    output reg [1:0]MemtoReg_out,
    output reg[31:0]Mem_Res_out
);
 always@(posedge reset or posedge clk) 
    begin
        if (reset) begin
        ALU_Res_out<=0;
        bus_B_out<=0;
        Rt_out<=0;
        RegWr_adout<=0;
        MemWrite_out<=0;
        MemRead_out<=0;
        RegWrite_out<=0;
        MemtoReg_out<=0;
        Mem_Res_out<=0;
        end 
        begin
        ALU_Res_out<= ALU_Res_in;
        bus_B_out<=bus_B_in;
        Rt_out<= Rt_in;
        RegWr_adout<= RegWr_adin;
        MemWrite_out<=  MemWrite_in;
        MemRead_out<=MemRead_in;
        RegWrite_out<=  RegWrite_in;
        MemtoReg_out<=MemtoReg_in;
        Mem_Res_out<= Mem_Res_in;
        end
    end
endmodule