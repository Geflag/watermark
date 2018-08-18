`timescale 1ns / 1ps
module DCT4
#(
	parameter [3:0]	 WIDTH =4'd8
)
(
	input  	  [WIDTH-1:0]  A0,
	input  	  [WIDTH-1:0]  A1,
	input  	  [WIDTH-1:0]  A2,
	input  	  [WIDTH-1:0]  A3,
	
	output 	signed  [WIDTH+2:0]  B0,
	output 	signed  [WIDTH+2:0]  B1,
	output 	signed  [WIDTH+2:0]  B2,
	output 	signed  [WIDTH+2:0]  B3
);

	wire    signed  [WIDTH:0]    AA0;
	wire    signed  [WIDTH:0]    AA1;
	wire    signed  [WIDTH:0]    AA2;
	wire    signed  [WIDTH:0]    AA3;
	
generate 															// 符号位扩展
	if (WIDTH == 4'd8)	 begin   
		assign	AA0 = {1'd0,A0};
		assign	AA1 = {1'd0,A1};
		assign	AA2 = {1'd0,A2};
		assign	AA3 = {1'd0,A3};	
	end
	else 				begin
		assign	AA0 = {A0[WIDTH-1],A0};
		assign	AA1 = {A1[WIDTH-1],A1};
		assign	AA2 = {A2[WIDTH-1],A2};
		assign	AA3 = {A3[WIDTH-1],A3};	
	end
endgenerate

	wire 	signed  [WIDTH+1:0]  C0;
	wire 	signed  [WIDTH+1:0]  C1;

	assign  C0 = AA0 + AA3;
	assign  C1 = AA1 + AA2;
	
	assign  B0 = C0  + C1;
	assign  B1 = AA0 - AA3;
	assign  B2 = C0  - C1;
	assign  B3 = AA2 - AA1;

endmodule