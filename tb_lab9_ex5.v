module tb;
  reg [15:0]a;
  reg [15:0]b;
  wire [31:0]p;
  
  mul16x16 mul_inst(.a(a),.b(b),.p(p));
  
  initial begin
    $dumpfile("forme_unda.vcd");
    $dumpvars(0,tb);
    a=16'd0;
    b=16'd0;
    #10;
    
    a=16'd16;
    b=16'd16;
    #10;
    
    a=16'd30;
    b=16'd50;
    #10;
    
    a=16'd36;
    b=16'd5;
    #10;
    
    #20;
    $finish;
  end
endmodule