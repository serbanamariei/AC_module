module tb;
  reg clk;
  reg [3:0]a;
  reg [3:0]b;
  wire [7:0]p;
  
  multi multi_inst(.clk(clk),.a(a),.b(b),.p(p));
  
  always #5 clk=~clk;
  
  initial begin
    $dumpfile("forme_unda.vcd");
    $dumpvars(0,tb);
    
    clk=0;
    a=4'd0;
    b=4'd0;
    #10;
    
    a=4'd3;
    b=4'd2;
    #10;
    
    a=4'd4;
    b=4'd4;
    #10;
    
    #20;
    $finish;
  end
endmodule