module tb;
  reg [7:0]a;
  reg [7:0]b;
  wire [15:0]p;
  
  mul8x8 mul_inst(.a(a),.b(b),.p(p));
  
  initial begin
    $dumpfile("forme_unda.vcd");
    $dumpvars(0,tb);
    
    a=7'b0;
    b=7'b0;
    #10;
    
    a=7'd5;
    b=7'd16;
    #10;
    
    a=7'd2;
    b=7'd25;
    #10;
    
    a=7'd6;
    b=7'd70;
    #10;
    
    #20;
    $finish;
  end
endmodule