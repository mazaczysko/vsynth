module register #(
    parameter W = 8 
)
(
    input               clk,
    input               ce,
    input      [W-1:0]  d,
    output reg [W-1:0]  q = 0
);

always @(posedge clk)
    if(ce)
        q <= d;

endmodule