// CALE DATE
module cale_date(
  	input clk, res,

    input IorD, MemRead, MemWrite, IRWrite, RegWrite, ALUSrcA,
    input [1:0] ALUSrcB, ALUOp,
    input PCWrite, PCWriteCond, PCSource, MemtoReg,

    output [6:0] opcode,
    output Zero
);
  
  reg [31:0] PC, IR, MDR, A, B, ALUOut;
  reg [7:0] mem [0:1023];
  reg [31:0] registers [0:31];
  
  integer i;
  initial begin
  	$readmemh("data.mem", mem);
    
    for (i = 0; i < 32; i = i + 1) begin
        registers[i] = 32'h0;
    end
  end
  
  // SEMNALE MEMORIE
  wire [31:0] addr_mem;
  wire [31:0] mem_data_read;
  
  // SEMNALE ALU
  wire [31:0] imm_ext;
  wire [31:0] srcA;
  wire [31:0] srcB;
  wire [31:0] alu_res;
  assign Zero=(alu_res==32'd0);
  assign imm_ext = {{20{IR[31]}}, IR[31:20]};
  
  
  // MEMORIA COMUNA
  assign addr_mem=(IorD==0) ? PC : ALUOut;
  
  always@(posedge clk) begin
    
    if (MemRead) begin		// CITIM DIN MEMORIE
      if (IRWrite)																	// AMBELE AICI SUNT IN ACELASI REGISTRU DE MEMORIE
        IR <= {mem[addr_mem+3], mem[addr_mem+2], mem[addr_mem+1], mem[addr_mem]};	// BAG IN INSTRUCTION REGISTER
      else
        MDR <= {mem[addr_mem+3], mem[addr_mem+2], mem[addr_mem+1], mem[addr_mem]};	// BAG IN MEMORY DATA REGISTER
    end
    
    if(MemWrite) begin		// SCRIEM IN MEMORIE CEEA CE IESE DIN REGISTRUL B
      mem[addr_mem]<=B[7:0];
      mem[addr_mem+1]<=B[15:8];
      mem[addr_mem+2]<=B[23:16];
      mem[addr_mem+3]<=B[31:24];
    end
  end
    
  // BANCUL DE REGISTRE
  always@(posedge clk) begin
    A<=registers[IR[19:15]];	// BAGAM IN REGISTRELE A SI B REGISTRELE CE SE AFLA PE POZITIILE 19-15 SI 24-20 DIN INSTRUCTION REGISTER
    B<=registers[IR[24:20]];
    
    if(RegWrite && IR[11:7]!=5'd0) begin					// SCRIEM IN BANCU DE REGISTRE UNDE NE SPUNE IR U
      registers[IR[11:7]]<= (MemtoReg==0) ? ALUOut : MDR;
  	end
  end
  assign opcode=IR[6:0];
  // REGISTRELE MELE
  wire [31:0] x10 = registers[10];	// a0
  wire [31:0] x11 = registers[11];	// a1
  wire [31:0] x12 = registers[12]; 	// a2
  
  // ALU
  assign srcA=(ALUSrcA==1) ? A : PC;	// DECIDE CARE ESTE PRIMUL OPERAND
  assign srcB=(ALUSrcB==0) ? B : (ALUSrcB==1) ? 32'd4 : (ALUSrcB==2) ? imm_ext : 32'd0;	// DECIDE CARE ESTE AL DOILEA OPERAND
  
  assign alu_res=(ALUOp==2'b00) ? srcA+srcB : (ALUOp==2'b01) ? srcA-srcB  : (ALUOp==2'b10) ? (($signed(srcA) < $signed(srcB)) ? 32'd1 : 32'd0) : 32'd0;
  
  always@(posedge clk) begin	// AM BAGAT IN REGISTRUL ALUOut REZULTATUL NOSTRU
    if(res) begin
      ALUOut<=32'd0;
    end
    else begin
      ALUOut<=alu_res;
    end
  end
  
  // LOGICA PC
  wire PCWrite_final;
  assign PCWrite_final=PCWrite || (PCWriteCond && Zero);	// IMPLEMENTAM LOGICA DE CONTROL
  
  always@(posedge clk) begin							// ATRIBUIM LUI PC VALOAREA
    if(res) begin
      PC<=32'd0;
    end
    else if(PCWrite_final) begin
      if(PCSource==0)
        PC<=alu_res;					// CAND SE FACE PC+4
      else
        PC<=ALUOut;						// CAND PC PRIMESTE VALOAREA CALCULATA DE LOGICA DE SALT ANTERIOR
    end
  end
  
endmodule

// CALE CONTROL
module cale_control(
  input clk,
  input res,
  
  input [6:0] opcode,
  
  output reg MemRead,
  output reg MemtoReg,
  output reg MemWrite,
  output reg ALUSrcA,
  output reg [1:0] ALUSrcB,
  output reg [1:0] ALUOp,
  output reg IorD,
  output reg IRWrite,
  output reg PCWrite,
  output reg PCSource,
  output reg RegWrite,
  output reg PCWriteCond
);
  
  reg [3:0] cs;
  reg [3:0] ns;
  
  always@({cs,opcode})
    casex({cs,opcode})
      11'b0000_xxxxxxx: ns=1;
      
      11'b0001_0000011,
      11'b0001_0100011: ns=2;
      11'b0001_0110011: ns=6;
      11'b0001_1100011: ns=8;
      11'b0001_0010011: ns = 9;
      
      11'b0010_0000011: ns=3;
      11'b0010_0100011: ns=5;
      
      11'b0011_xxxxxxx: ns=4;
      
      11'b0110_xxxxxxx: ns=7;
      
      11'b1001_xxxxxxx: ns = 10;
      
      11'b1010_xxxxxxx: ns = 0;
      
      default: ns=0;
      
    endcase
  
  always@(posedge clk)
    if(res==1)
      cs<=0;
  	else
      cs<=ns;
  
  always@(*) begin
    
    MemRead = 0; MemWrite = 0; RegWrite = 0; IRWrite = 0; 
    PCWrite = 0; PCWriteCond = 0; IorD = 0; MemtoReg = 0;
    PCSource = 0; ALUSrcA = 0; ALUSrcB = 2'b00; ALUOp = 2'b00;
    
    case(cs)
      4'b0000: begin
        MemRead=1;
        ALUSrcA=0;
        IorD=0;
        IRWrite=1;
        ALUSrcB=2'b01;
        ALUOp=2'b00;
        PCWrite=1;
        PCSource=0;
      end
      
      4'b0001: begin
        ALUSrcA=0;
        ALUSrcB=2'b10;
        ALUOp=2'b00;
      end
      
      4'b0010: begin
        ALUSrcA=1;
        ALUSrcB=2'b10;
        ALUOp=2'b00;
      end
      
      4'b0011: begin
        MemRead=1;
        IorD=1;
      end
      
      4'b0100: begin
        RegWrite=1;
        MemtoReg=1;
      end
      
      4'b0101: begin
        MemWrite=1;
        IorD=1;
      end
      
      4'b0110: begin
        ALUSrcA=1;
        ALUSrcB=2'b00;
        ALUOp=2'b10;
      end
      
      4'b0111: begin
        RegWrite=1;
        MemtoReg=0;
      end
      
      4'b1000: begin
        ALUSrcA=1;
        ALUSrcB=2'b00;
        ALUOp=2'b01;
        PCWriteCond=1;
        PCSource=1;
      end
      
      4'b1001: begin
        ALUSrcA = 1;
        ALUSrcB = 2'b10;
        ALUOp = 2'b00;
      end
      
      4'b1010: begin
        RegWrite = 1;
        MemtoReg = 0;
      end
      
      default: begin
       	MemRead=0;
  		MemtoReg=0;
  		ALUSrcA=0;
  		ALUSrcB=2'b00;
  		ALUOp=2'b00;
  		IorD=0;
  		IRWrite=0;
  		PCWrite=0;
  		PCSource=0;
        RegWrite=0;
        PCWriteCond=0;
      end
    endcase
  end
  
endmodule

module riscv_multi(
    input clk,
    input res
);
    // firele care fac legatura intre control si date
    wire [6:0] opcode;
    wire Zero, IorD, MemRead, MemWrite, IRWrite, RegWrite, ALUSrcA, MemtoReg;
    wire [1:0] ALUSrcB, ALUOp;
    wire PCWrite, PCWriteCond, PCSource;

    // instanta cale de control
    cale_control cale_control_inst(
        .clk(clk), .res(res), .opcode(opcode),
        .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite),
        .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ALUOp(ALUOp),
        .IorD(IorD), .IRWrite(IRWrite), .PCWrite(PCWrite),
        .PCWriteCond(PCWriteCond), .RegWrite(RegWrite), .PCSource(PCSource)
    );

    // instanta cale date
    cale_date cale_date_inst(
        .clk(clk), .res(res),
        .IorD(IorD), .MemRead(MemRead), .MemWrite(MemWrite),
        .IRWrite(IRWrite), .RegWrite(RegWrite), .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB), .ALUOp(ALUOp),
        .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), .PCSource(PCSource),
        .MemtoReg(MemtoReg),
        .opcode(opcode), .Zero(Zero)
    );
endmodule