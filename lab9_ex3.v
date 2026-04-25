// EX 1

module mul_np(
  input [3:0] a,
  input [3:0] b,
  output [7:0] p
);

// !!! high level !!!
// not suited for digital desgn 
//  assign p = a * b; 
  
  wire [4:0] s0;
  wire [4:0] s1;
  wire [4:0] s2;
  
  assign s0 = 
  	{{1'b0},a[3]&b[0],a[2]&b[0],a[1]&b[0]}	+ 
  	{a[3]&b[1],a[2]&b[1],a[1]&b[1],a[0]&b[1]};

  assign s1 = 
  	{s0[4:1]} +
  	{a[3]&b[2],a[2]&b[2],a[1]&b[2],a[0]&b[2]};
  
  assign s2 = 
  	{s1[4:1]} +
  	{a[3]&b[3],a[2]&b[3],a[1]&b[3],a[0]&b[3]};
  
  assign p = { s2, s1[0], s0[0], a[0]&b[0]};
  
endmodule

module mul_4x8(
  input [3:0]a,
  input [7:0]b,
  output [11:0]p
);
  
  wire [7:0]p_low;
  wire [7:0]p_high;
  
  mul_np inst_low(
    .a(a),
    .b(b[3:0]),
    .p(p_low)
  );
  
  mul_np inst_high(
    .a(a),
    .b(b[7:4]),
    .p(p_high)
  );
  
  assign p=(p_high<<4)+p_low;
endmodule