module IDCT4 
#(
    parameter [3:0] WIDTH = 4'd8
)(
    input   signed  [WIDTH-1:0] A0,
    input   signed  [WIDTH-1:0] A1,
    input   signed  [WIDTH-1:0] A2,
    input   signed  [WIDTH-1:0] A3,

    output  signed  [WIDTH-1:0] B0,
    output  signed  [WIDTH-1:0] B1,
    output  signed  [WIDTH-1:0] B2,
    output  signed  [WIDTH-1:0] B3
    
);

    // wire signed     [WIDTH-1:0] tmp0;
    // wire signed     [WIDTH-1:0] tmp1;

    // wire signed     [WIDTH-1:0] A0_d2;
    // wire signed     [WIDTH-1:0] A1_d2;
    // wire signed     [WIDTH-1:0] A2_d2;
    // wire signed     [WIDTH-1:0] A3_d2;

    // assign  A0_d2 = A0 >>> 1;
    // assign  A1_d2 = A1 >>> 1;
    // assign  A2_d2 = A2 >>> 1;
    // assign  A3_d2 = A3 >>> 1;
    
    // assign  tmp0 = (A0_d2 >>> 1) + (A2_d2 >>> 1);  // >>> 有符号数除以二向负无穷取整。
    // assign  tmp1 = (A0_d2 >>> 1) - (A2_d2 >>> 1);

    // assign  B0 = tmp0 + A1_d2;
    // assign  B1 = tmp1 - A3_d2;
    // assign  B2 = tmp1 + A3_d2;
    // assign  B3 = tmp0 - A1_d2;

    wire signed     [WIDTH:0] tmp0;
    wire signed     [WIDTH:0] tmp1;  
    wire signed     [WIDTH:0] A1_mul2;
    wire signed     [WIDTH:0] A3_mul2;
    wire signed     [WIDTH+1:0] B0_pad;
    wire signed     [WIDTH+1:0] B1_pad;
    wire signed     [WIDTH+1:0] B2_pad;
    wire signed     [WIDTH+1:0] B3_pad;
    
    assign tmp0 = A0 + A2;
    assign tmp1 = A0 - A2;
    assign A1_mul2 = A1 <<< 1;
    assign A3_mul2 = A3 <<< 1;

    assign B0_pad = tmp0 + A1_mul2;
    assign B1_pad = tmp1 - A3_mul2;
    assign B2_pad = tmp1 + A3_mul2;
    assign B3_pad = tmp0 - A1_mul2;

    assign B0 = B0_pad >>> 2;
    assign B1 = B1_pad >>> 2;
    assign B2 = B2_pad >>> 2;
    assign B3 = B3_pad >>> 2;

endmodule