module Hazard_Flush(
input ID_EX_MemRead,
input [4:0]ID_EX_rs,
input [4:0]ID_EX_rt,
input [4:0]IF_ID_rs,
input [4:0]IF_ID_rt,
input EX_branch,
input ID_EX_regwr,
input [4:0]ID_EX_rd,
input EX_MEM_memread,
input [4:0]EX_MEM_regwrad,
input ID_jump,
input EX_Zore,
output reg [4:0]stall,
output reg  [4:0]flush
);
always @(*)
begin
if(ID_EX_MemRead &&(ID_EX_rt==IF_ID_rs||ID_EX_rt==IF_ID_rt))
      stall<=5'b00011;

else     stall<=5'b00000;  
if(ID_jump)
flush<=5'b00001;
if(EX_branch && EX_Zore) flush<=5'b00011;
else flush<=5'b00000;
end
endmodule