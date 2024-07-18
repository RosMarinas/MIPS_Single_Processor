module Forwarding(
	input [4:0] IF_ID_rs,
    input [4:0] IF_ID_rt,
    input [4:0] ID_EX_rs,
    input [4:0] ID_EX_rt,
    input [4:0] EX_MEM_rt,
    input [4:0] EX_MEM_regwrad,
    input [4:0] MEM_WB_regwrad,
    input EX_MEM_regwr,
    input MEM_WB_regwr,
    input EX_MEM_memWr,
    input MEM_WB_memRd,
	output reg MUX_A1,
    output reg MUX_A2,
	output reg [1:0] MUX_B1,
    output reg [1:0]MUX_B2,
    output reg MUX_C
);
	always @ (*)
	begin
        if(MEM_WB_regwr && MEM_WB_regwrad == IF_ID_rs) MUX_A1 <= 1;
        else MUX_A1 <= 0;

        if(MEM_WB_regwr && MEM_WB_regwrad == IF_ID_rt) MUX_A2 <= 1;
        else MUX_A2 <= 0;

        //MUX before ALU
        if(ID_EX_rs!=0 && EX_MEM_regwr &&  EX_MEM_regwrad == ID_EX_rs) MUX_B1<=2;
        else if(ID_EX_rs!=0 && MEM_WB_regwr && MEM_WB_regwrad == ID_EX_rs) MUX_B1<=1;
        else MUX_B1<=0;

        if(ID_EX_rt && EX_MEM_regwr && EX_MEM_regwrad == ID_EX_rt) MUX_B2<=2;
        else if(ID_EX_rt!=0 && MEM_WB_regwr && MEM_WB_regwrad == ID_EX_rt) MUX_B2<=1;
        else MUX_B2<=0;

        //MUX before Data Memory
        if(EX_MEM_rt!=0 && EX_MEM_memWr && MEM_WB_memRd && (MEM_WB_regwrad == EX_MEM_rt)) MUX_C<=1;
        else MUX_C<=0;
        
  
	end
endmodule