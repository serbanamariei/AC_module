module tb;
  parameter WORD_SIZE=32;
  parameter ARRAY_SIZE=256;
  
  reg[$clog2(ARRAY_SIZE-1):0] addr_tb;
  wire [WORD_SIZE-1:0] dout_tb;
  
  memory#(WORD_SIZE,ARRAY_SIZE) memory_inst(
    .addr(addr_tb),
    .dout(dout_tb)
  );
  
  initial begin
    $dumpfile("forma_unde.vcd");
    $dumpvars(0,tb);
    
    $display("memorie asincrona");
    
    addr_tb=0;
    #10;
    $display("Adresa: %d | Valoarea: %h", addr_tb, dout_tb);
    
    
    addr_tb=1;
    #10;
    $display("Adresa: %d | Valoarea: %h", addr_tb, dout_tb);
    
    addr_tb=2;
    #10;
    $display("Adresa: %d | Valoarea: %h", addr_tb, dout_tb);
    
    $finish;
  end
  
endmodule