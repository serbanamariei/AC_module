module bancRegistre#(
  parameter WORD_SIZE=32,
  parameter ARRAY_SIZE=32
)(
  input clk,
  input wen,
  
  input [$clog2(ARRAY_SIZE)-1:0] RA,
  output [WORD_SIZE-1:0] DA,
  
  input [$clog2(ARRAY_SIZE)-1:0] RB,
  output [WORD_SIZE-1:0] DB,
  
  input [$clog2(ARRAY_SIZE)-1:0] RC,
  input [WORD_SIZE-1:0] DC
);
  
  reg [WORD_SIZE-1:0] registre [0:ARRAY_SIZE-1];
  
  assign DA=registre[RA];
  assign DB=registre[RB];
  
  always@(posedge clk) begin
    if(wen) begin
      registre[RC]<=DC;
    end
  end
    
endmodule