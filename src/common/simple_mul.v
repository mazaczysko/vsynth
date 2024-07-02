module simple_mul #(
    parameter WIDTH_A = 8,
    parameter WIDTH_B = 8
)
(
    input                            clk,
    input                            rst,
    input                            ce,
    input      [WIDTH_A-1:0]         a,
    input      [WIDTH_B-1:0]         b,
    output reg [WIDTH_A+WIDTH_B-1:0] res,
    output reg                       res_dv
);


always @(posedge clk)
    if(rst)
        res <= 0;
    else if (ce)
        res <= a*b;

always @(posedge clk)
    if(rst)
        res_dv <= 0;
    else
        res_dv <= ce;


endmodule