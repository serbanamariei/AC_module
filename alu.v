module alu#(
  parameter WORD_SIZE=32
)
  (
    input [WORD_SIZE-1:0] A,
    input [WORD_SIZE-1:0] B,
    input [2:0] ALUOp,
    output reg [WORD_SIZE-1:0] Result,
    output reg ZERO
  );
  
  always@(*) begin
    casex(ALUOp)
      3'b000: Result=A+B;
      3'b001: Result=A-B;
      3'b010: Result=A & B;
      3'b011: Result=A | B;
      3'b100: Result=~(A | B);
      3'b101: Result=A ^ B;
      3'b110: Result=($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
      default: Result=32'd0;
    endcase
    
  	if(Result==0)
    	ZERO=1'b1;
  	else
    	ZERO=1'b0;  
  end
  
endmodule