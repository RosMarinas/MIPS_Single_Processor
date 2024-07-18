module CPU (reset, clk,digi);

    input reset;
    input clk;
    output wire [11:0] digi;


    reg  [31 :0] PC;
	reg [31 :0] PC_next;
	reg [31 :0] PC_plus_4;
 /*control unit*/
    wire [1:0] PCSrc;
	wire ID_branch;
	wire RegWrite;
	wire [1:0] RegDst;
	wire MemRead;
	wire MemWrite;
	wire [1:0]MemtoReg;
    wire ALUSrc1;
	wire ALUSrc2;
	wire ExtOp;
	wire LuOp;
    wire [4 -1:0] ALUOp;
    /*ALUControl*/
    wire [4:0] ALUCtrl;
    wire Sign;
    wire [31:0]ALU_out;
    /*additional controller in pipeline*/
    wire ID_jump;//whether to stall the pipeline

    /*pre_branch*/
    wire EX_zero;

    wire MUX_A1;
    wire  MUX_A2;
	wire [1:0] MUX_B1;
    wire [1:0]MUX_B2;
    wire MUX_C;

    /*Hazard and flush unit*/
    wire [4:0]stall;
    wire [4:0]flush;

    /*MUX data*/
    wire [31:0] ALU_in1;//ALUSrc 1
    wire [31:0] ALU_in2;//ALUSrc 2
    wire [31:0] ALU_Res;//ID_EX_if_jal :ALUresult or PC(for jal or jalr)
    wire [31:0] bus_A,bus_B;//MUX_bus_A MUX_bus_B

    /*Instruction Memory*/
    wire [31:0] Instruction;

    /*IF/ID register*/
    wire [31:0] IF_ID_Instruction,IF_ID_PC4;

    /*imm_process*/
    wire [31:0] Extend_imm;
    wire [31:0] imm_ext_shift;
	// Register File
	wire [32 -1:0] Databus1;
	wire [32 -1:0] Databus2; 
	wire [32 -1:0] Databus3;
	wire [5  -1:0] Write_register;
    /*ID/EX register*/
    wire [31:0] ID_EX_ALU_in1;
    wire [31:0]ID_EX_ALU_in2;
    wire ID_EX_ALUSrc2;
    wire ID_EX_ALUSrc1;
    wire [4:0] ID_EX_rs,ID_EX_rt,ID_EX_rd,ID_EX_ALUCtrl;
    wire [1:0] ID_EX_RegDst;
    wire [31:0]ID_EX_PC4;
    wire ID_EX_MemWrite;
    wire ID_EX_MemRead;
    wire ID_EX_RegWrite;
    wire [1:0]ID_EX_MemtoReg;
    wire ID_EX_branch;
    wire  [5:0]ID_EX_Zero_pd;
    wire [31:0]ID_EX_imm;
    wire ID_EX_Sign;
       wire [31:0]ID_EX_Ext_out;
    /*EX/MEM register*/
    wire [31:0] EX_MEM_ALU_out;
    wire [31:0]EX_MEM_Databus2;
    wire [31:0]EX_MEM_PC4;
  
    wire [4:0] EX_MEM_rt,EX_MEM_RegWrAddr;
    wire EX_MEM_MemWrite,EX_MEM_MemRead,EX_MEM_RegWrite;
    wire [1:0]EX_MEM_MemtoReg;
	wire [32 -1:0] Ext_out;

    /*MEM/WB register*/
    wire [4:0] MEM_WB_RegWrAddr;
    wire [31:0] MEM_WB_ALU_out;
    wire [31:0]MEM_WB_mem_out;
    wire MEM_WB_MemWrite;
    wire [31:0]MEM_WB_PC4;
    wire MEM_WB_RegWrite;
    wire [1:0]MEM_WB_MemtoReg;
  wire [4:0]MEM_WB_rt;
    wire [31:0] Write_data;
   wire     MEM_WB_MemRead;
   reg ID_zero;
wire [32 -1:0] LU_out;

initial
    begin PC <= 32'b0;
     PC_next <= 32'b0; 
     end
	always @(posedge reset or posedge clk)
		if (reset)
			PC <= 32'h00000000;
		else
			PC <= PC_next;


  Forwarding forw(
    IF_ID_Instruction[25:21],
    IF_ID_Instruction[20:16],
    ID_EX_rs,
    ID_EX_rt,
    EX_MEM_rt,
    EX_MEM_RegWrAddr,
    MEM_WB_RegWrAddr,
    EX_MEM_RegWrite,
    MEM_WB_RegWrite,
    EX_MEM_MemWrite,
    MEM_WB_MemRead,
	MUX_A1,
    MUX_A2,
	MUX_B1,
    MUX_B2,
    MUX_C

   );
    Hazard_Flush hazard_flush(
    ID_EX_MemRead,
    ID_EX_rs,
    ID_EX_rt,
    IF_ID_Instruction[25:21],
     IF_ID_Instruction[20:16],
    ID_EX_branch,
    ID_EX_RegWrite,
    ID_EX_rd,
    EX_MEM_MemRead,
    EX_MEM_RegWrAddr,
    ID_jump,
    EX_zero,
    stall,
    flush
    );

always @ (*)
    begin
        PC_plus_4<= PC + 4;//PC adder for jal and jalr
        if(stall[0])
				PC_next<=PC;
        else
            begin 
                    if(ID_EX_branch && EX_zero)  PC_next<= {ID_EX_Ext_out[29:0], 2'b00}+ID_EX_PC4;
                    else if(ID_jump)
                    begin
                    case(PCSrc)
                 1: PC_next<= {IF_ID_PC4[31:28],(IF_ID_Instruction[25:0]<<2)};
                 2:PC_next<=Databus1;
                   endcase
                   end
                 else  PC_next<=PC+4;
            end
		end

InstructionMemory ins(
    PC,
    Instruction
);
IF_ID if_id(
    reset,
	clk,
	PC_plus_4,
	Instruction,
	stall,
	flush,
	IF_ID_PC4,
	IF_ID_Instruction
);
Control control(
	IF_ID_Instruction[31:26],
	IF_ID_Instruction[5:0], 
	PCSrc    ,
	ID_branch            ,
    RegWrite          ,
	RegDst   ,
	MemRead           ,
	MemWrite          ,
	MemtoReg ,
	ALUSrc1           ,
	ALUSrc2           ,
	ExtOp             ,
	LuOp              ,
	ALUOp,
	ID_jump
    );
ALUControl ALUcontrol(
	ALUOp      ,
	IF_ID_Instruction[5:0], 
	ALUCtrl ,
	Sign
);

	assign Ext_out = { ExtOp? {16{IF_ID_Instruction[15]}}: 16'h0000, IF_ID_Instruction[15:0]};
	
	assign LU_out = LuOp? {IF_ID_Instruction[15:0], 16'h0000}: Ext_out;
    /*RF*/
    wire [31:0] Read_data1;//originally read from the RF
    wire [31:0] Read_data2;

RegisterFile RegFile(
    reset, 
    clk,
    MEM_WB_RegWrite, 
    IF_ID_Instruction[25:21],
    IF_ID_Instruction[20:16],
    MEM_WB_RegWrAddr,
    Write_data,
    Read_data1,
    Read_data2
    );
    assign Databus1=MUX_A1==0?Read_data1:Write_data;
    assign Databus2=MUX_A2==0?Read_data2:Write_data;
    


    assign ALU_in1 = ALUSrc1? {27'h00000, IF_ID_Instruction[10:6]}: Databus1;
	assign ALU_in2 =   ALUSrc2? LU_out: Databus2;
    wire [31:0]databus2;

    ID_EX id_ex(
    reset,
    clk,
    Sign,
    stall,
    flush,
    Databus2,
    Ext_out,
    IF_ID_PC4,
    ALU_in1,
    ALU_in2,
    MemWrite,
    MemRead,
    RegWrite,
    MemtoReg,
    ALUCtrl,
    ALUSrc1,
    ALUSrc2,
    IF_ID_Instruction[25:21],
    IF_ID_Instruction[20:16],
    IF_ID_Instruction[15:11],
    ID_branch,
    IF_ID_Instruction[31:26],
    RegDst,
    ID_EX_PC4,
    ID_EX_ALU_in1,
    ID_EX_ALU_in2,
    ID_EX_MemWrite,
    ID_EX_MemRead,
    ID_EX_RegWrite,
    ID_EX_MemtoReg,
    ID_EX_ALUCtrl,
    ID_EX_ALUSrc1,
    ID_EX_ALUSrc2,
    ID_EX_rs,
    ID_EX_rt,
    ID_EX_rd,
    ID_EX_branch,
    ID_EX_Zero_pd,
    ID_EX_RegDst,
    ID_EX_Sign,
    ID_EX_Ext_out,
    databus2
);
wire [31:0] ALU1;
wire [31:0] ALU2;
wire [31:0]memwritedata;
 assign ALU1=MUX_B1==2?EX_MEM_ALU_out:(MUX_B1==1?Write_data:ID_EX_ALU_in1);
 assign ALU2=ID_EX_ALUSrc2==1?ID_EX_ALU_in2:(MUX_B2==2?EX_MEM_ALU_out:(MUX_B2==1?Write_data:ID_EX_ALU_in2));
assign memwritedata=MUX_B2==2?EX_MEM_ALU_out:(MUX_B2==1?Write_data:databus2);
 ALU alu(
    ID_EX_Zero_pd,
	ALU1     , 
	ALU2      ,
	ID_EX_ALUCtrl    ,
	ID_EX_Sign               ,
	ALU_out ,
	EX_zero
 );
 assign Write_register = ( ID_EX_RegDst == 2'b00)? ID_EX_rt: ( ID_EX_RegDst == 2'b01)? ID_EX_rd: 5'b11111;
 EX_MEM ex_mem(
    reset,
    clk,
    stall,
   memwritedata,
    ID_EX_PC4,
    ALU_out,
    ID_EX_rt,
    Write_register,
    ID_EX_MemWrite,
    ID_EX_MemRead,
    ID_EX_RegWrite, 
    ID_EX_MemtoReg,
    EX_MEM_Databus2,
    EX_MEM_ALU_out,
    EX_MEM_rt,
    EX_MEM_RegWrAddr,
    EX_MEM_MemWrite,
    EX_MEM_MemRead,
    EX_MEM_RegWrite,
    EX_MEM_MemtoReg,
    EX_MEM_PC4
);

    /*DM*/
    wire [31:0] DataMem_WriteData;
    wire [31:0] DataMem_out;
    assign DataMem_WriteData=MUX_C==1?Write_data:EX_MEM_Databus2;
    DataMemory datamem(
	reset    , 
	clk      ,  
	EX_MEM_MemRead  ,
	EX_MEM_MemWrite ,
	EX_MEM_ALU_out   ,
	DataMem_WriteData ,
	DataMem_out,
	digi
);


 MEM_WB memwb(
    reset,
    clk,
    stall,
    EX_MEM_ALU_out,
    EX_MEM_PC4,
    EX_MEM_rt,
    EX_MEM_RegWrAddr,
    EX_MEM_MemWrite,
    EX_MEM_MemRead,
    EX_MEM_RegWrite, 
    EX_MEM_MemtoReg,
    DataMem_out, 
    MEM_WB_ALU_out,
    MEM_WB_PC4,
    MEM_WB_rt,
    MEM_WB_RegWrAddr,
    MEM_WB_MemWrite,
    MEM_WB_MemRead,
    MEM_WB_RegWrite,
    MEM_WB_MemtoReg,
    MEM_WB_mem_out
);


    assign Write_data= (MEM_WB_MemtoReg == 2'b00)? MEM_WB_ALU_out: (MEM_WB_MemtoReg == 2'b01)? MEM_WB_mem_out: MEM_WB_PC4;
    endmodule