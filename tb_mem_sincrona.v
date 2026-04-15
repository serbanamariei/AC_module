module tb;
  parameter WORD_SIZE=32;
  parameter ARRAY_SIZE=32;
  
  reg clk;
  reg wen_tb;
  reg [$clog2(ARRAY_SIZE)-1:0] addr_tb;
  reg [WORD_SIZE-1:0] din_tb;
  wire [WORD_SIZE-1:0] dout_tb;
  
  memory #(WORD_SIZE,ARRAY_SIZE) memory_inst (
    .clk(clk),
    .wen(wen_tb),
    .addr(addr_tb),
    .din(din_tb),
    .dout(dout_tb)
  );
  
  initial clk=0;
  always #5 clk=~clk;
    
  
  initial begin
    $dumpfile("forme_unda.vcd");
    $dumpvars(0,tb);
    
    $display("memorie sincrona");
    
    wen_tb=0;
    din_tb=0;
    addr_tb=0;
    
    #10;
    addr_tb=2;
    din_tb=32'h12345678;
    wen_tb=1;
    #10;
    wen_tb=0;
    
    #10;
    addr_tb=3;
    din_tb=32'h67676767;
    wen_tb=1;
    #10;
    wen_tb=0;
    
    #10;
    addr_tb=0;
    #1;
    $display("Adresa: %d | Valoarea: %h",addr_tb,dout_tb);
    
    #10;
    addr_tb=1;
    #1;
    $display("Adresa: %d | Valoarea: %h",addr_tb,dout_tb);
    
    #10;
    addr_tb=2;
    #1;
    $display("Adresa: %d | Valoarea: %h",addr_tb,dout_tb);
    
    #10;
    addr_tb=3;
    #1;
    $display("Adresa: %d | Valoarea: %h",addr_tb,dout_tb);
    
    #10;
    addr_tb=4;
    #1;
    $display("Adresa: %d | Valoarea: %h",addr_tb,dout_tb);
    
    #20;
    $finish;
  end
  
endmodule