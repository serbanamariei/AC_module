module tb;
  reg clk_tb;
  reg res_tb;
  
  reg [6:0] opcode_tb;
  
  wire MemRead_tb;
  wire MemtoReg_tb;
  wire ALUSrcA_tb;
  wire [1:0] ALUSrcB_tb;
  wire [1:0] ALUOp_tb;
  wire IorD_tb;
  wire IRWrite_tb;
  wire PCWrite_tb;
  wire PCSource_tb;
  wire RegWrite_tb;
  wire MemWrite_tb;
  wire PCWriteCond_tb;
  
  cale_control cale_control_inst(
    .clk(clk_tb), .res(res_tb), .opcode(opcode_tb), .MemWrite(MemWrite_tb),
    .MemRead(MemRead_tb), .MemtoReg(MemtoReg_tb), .ALUSrcA(ALUSrcA_tb),
    .ALUSrcB(ALUSrcB_tb), .ALUOp(ALUOp_tb), .IorD(IorD_tb),
    .IRWrite(IRWrite_tb), .PCWrite(PCWrite_tb), .PCSource(PCSource_tb),
    .RegWrite(RegWrite_tb), .PCWriteCond(PCWriteCond_tb)
  );
  
  initial clk_tb=0;
  always #5 clk_tb=~clk_tb;
  
  initial begin
    $dumpfile("forme_unda.vcd");
    $dumpvars(0,tb);
    

    res_tb = 1; opcode_tb = 7'b0;
    #12;
    res_tb = 0;


    opcode_tb = 7'b0110011; 
    #50;

    opcode_tb = 7'b0000011;
    #60;

    opcode_tb = 7'b0010011;
    #50;

    $finish;
  end
endmodule