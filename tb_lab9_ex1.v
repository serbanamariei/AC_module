module tb_mulp();

    reg clk;
  reg [3:0] a;
  reg [3:0] b;
    
  wire [7:0] p;
    
    mul_np DUT(
        clk,
        a,
        b,
        p
    );

    initial begin
      $dumpfile("forme_unda.vcd");
      $dumpvars(0,tb_mulp);
        clk = 0; a = 0; b = 0;
        #10 a = 1;
        #10 b = 2;
        #10 a = 4;
        #10 b = 3;
        #10 a = 8;
        #10 b = 10;
        #10 a = 15;
        #10 b = 13;
        #10 $finish();
       
    end
    
    always #5 clk = ~clk;
    
endmodule