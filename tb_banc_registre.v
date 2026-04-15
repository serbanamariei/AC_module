module tb;
  parameter WORD_SIZE=32;
  parameter ARRAY_SIZE=32;
  
  reg clk;
  reg wen_tb;
  
  reg [$clog2(ARRAY_SIZE)-1:0] RA_tb;
  wire [WORD_SIZE-1:0] DA_tb;
  
  reg [$clog2(ARRAY_SIZE)-1:0] RB_tb;
  wire [WORD_SIZE-1:0] DB_tb;
  
  reg [$clog2(ARRAY_SIZE)-1:0] RC_tb;
  reg [WORD_SIZE-1:0] DC_tb;
  
  bancRegistre#(WORD_SIZE,ARRAY_SIZE) bancRegistre_inst(
    .clk(clk),
    .wen(wen_tb),
    .RA(RA_tb),
    .DA(DA_tb),
    .RB(RB_tb),
    .DB(DB_tb),
    .RC(RC_tb),
    .DC(DC_tb)
  );
  
  initial clk=0;
  always #5 clk=~clk;
  
  initial begin
    $dumpfile("forme_unda.vcd");
    $dumpvars(0,tb);
    
    $display("banc registre");
    
    wen_tb=0;
    RC_tb=0;
    DC_tb=0;
    
    RA_tb=0;
    RB_tb=1;
    
    #10;
    RC_tb=6;
    DC_tb=32'h12345678;
    wen_tb=1;
    #10;
    wen_tb=0;
    
    #10;
    RC_tb=7;
    DC_tb=32'h67676767;
    wen_tb=1;
    #10;
    wen_tb=0;
    
    #10;
    RA_tb=6;
    RB_tb=7;
    
    #20;
    $finish;
  end
  
endmodule