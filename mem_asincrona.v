module memory#(
  parameter WORD_SIZE=32,
  parameter ARRAY_SIZE=256
)
  (
    input [$clog2(ARRAY_SIZE)-1:0] addr,
    output [WORD_SIZE-1:0] dout
  );
  
  reg [WORD_SIZE-1:0] memory [0:ARRAY_SIZE-1];
  
  initial begin
    $readmemh("data.mem",memory);
  end
  
  assign dout=memory[addr];
  
endmodule