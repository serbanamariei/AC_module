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
  
  always@(cs)
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
        ALUOp = 2'b10;
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
  
endmodule