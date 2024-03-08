module register #(
    parameter W=8 
)
(
    input               CLK,
    input               CE,
    input [W-1:0]       D,
    output reg [W-1:0]  Q = 0
);

always @(posedge CLK)
    if(CE)
        Q <= D;

endmodule