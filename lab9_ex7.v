module multi(
  input clk,
  input [3:0]a,
  input [3:0]b,
  output reg [7:0]p
);
  
  reg [4:0]suma_mijloc;
  reg [3:0]rp_A, rp_B;
  reg p1;
  reg p0;
  
  wire [3:0]line0=a&{4{b[0]}};
  wire [3:0]line1=a&{4{b[1]}};
  
  reg [4:0]suma1;
  reg [4:0]suma2;
  reg [3:0]line2=rp_A & {4{rp_B[2]}};
  reg [3:0]line3=rp_A & {4{rp_B[3]}};
  
  always@(posedge clk)begin
    suma_mijloc<=line0[3:1]+line1;
    p0<=line0[0];
    rp_A<=a;
    rp_B<=b;
    
    line2=rp_A & {4{rp_B[2]}};
    line3=rp_A & {4{rp_B[3]}};
    
    suma1=suma_mijloc[4:1]+line2;
    suma2=suma1[4:1]+line3;
      
    p<={suma2,suma1[0],suma_mijloc[0],p0};
  end
endmodule