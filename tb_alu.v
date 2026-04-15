module tb;
  parameter WORD_SIZE=32;
  
  reg [WORD_SIZE-1:0] A_tb;
  reg [WORD_SIZE-1:0] B_tb;
  reg [2:0] ALUOp_tb;
  wire [WORD_SIZE-1:0] Result_tb;
  wire ZERO_tb;
  
  alu#(WORD_SIZE) alu_inst(
    .A(A_tb),
    .B(B_tb),
    .ALUOp(ALUOp_tb),
    .Result(Result_tb),
    .ZERO(ZERO_tb)
  );
  
  initial begin
    $dumpfile("forme_unda.vcd");
    $dumpvars(0,tb);
    
  	#10;
  	A_tb=32'h0;
 	B_tb=32'h67;
  	ALUOp_tb=3'b000;
  	#10;
  
  	A_tb=32'b101;
    B_tb=32'b010;
    ALUOp_tb=3'b010;
    
  	#20;
  	$finish;
  end
  
endmodule