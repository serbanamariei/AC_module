module multi(
  input clk,
  input [3:0]A,
  input [3:0]B,
  output reg [7:0]P 
);
  
  reg [3:0] rp1;
  reg [3:0] rp1_A;
  reg [3:0] rp1_B;
  
  reg [4:0] rp2;
  reg p0;
  reg [3:0] rp2_A;
  reg [3:0] rp2_B;
  
  reg [4:0] rp3;
  reg [1:0] p10;
  reg [3:0] rp3_A;
  reg [3:0] rp3_B;
  
  
  always@(posedge clk)begin
    rp1<=A&{4{B[0]}};
    rp1_A<=A;
    rp1_B<=B;
    
    rp2<=rp1[3:1]+(rp1_A&{4{rp1_B[1]}});
    p0<=rp1[0];
    rp2_A<=rp1_A;
    rp2_B<=rp1_B;
    
    rp3<=rp2[4:1]+(rp2_A&{4{rp2_B[2]}});
    p10<={rp2[0],p0};
    rp3_A<=rp2_A;
    rp3_B<=rp2_B;
    
    P<={(5'b0+rp3[4:1]+(rp3_A&{4{rp3_B[3]}})),rp3[0],p10};
  end
endmodule