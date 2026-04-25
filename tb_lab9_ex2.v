module tb;
  reg clk;
  reg [3:0]A;
  reg [3:0]B;
  wire [7:0]P;
  
  multi multi_inst(
    .clk(clk), .A(A), .B(B), .P(P)
  );
  
  always #5 clk=~clk;
  
  initial begin
    $dumpfile("forme_unda.vcd");
    $dumpvars(0,tb);
    clk=0;
    A=0;
    B=0;
    
    @(posedge clk);
	#1;A = 4'd2; B = 4'd3;
        
	@(posedge clk);
	#1;A = 4'd4; B = 4'd4;
        
	@(posedge clk);
	#1;A = 4'd15; B = 4'd15;

	@(posedge clk);
	#1;A = 4'd10; B = 4'd5;

	@(posedge clk);
	#1;A = 0; B = 0;

	repeat(4) @(posedge clk);
    
    #200

    $finish;
  end
endmodule