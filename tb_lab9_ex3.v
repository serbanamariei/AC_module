module tb;
  
  reg [3:0]a;
  reg [7:0]b;
  wire [11:0]p;
  
  mul_4x8 mul_inst(.a(a),.b(b),.p(p));
  
  initial begin
    $dumpfile("forme_unda.vcd");
    $dumpvars(0,tb);
    
    a=4'd0;
    b=8'd255;
    #10;
    
    a=4'd2; b=8'd4;
    #10;
    
    a=4'd2; b=8'd16;
    #10;
    
    a=4'd10; b=8'd100;
    #10;
    
    #10;
    $finish;
  end
endmodule