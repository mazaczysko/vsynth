module register_clr #(
    parameter W=8 
)
(
    input               CLK,
    input               CE,
    input               CLR,
    input [W-1:0]       D,
    output reg [W-1:0]  Q = 0
);

always @(posedge CLK)
    if (CLR)
        Q <= {W{1'd0}};
    else if (CE)    
        Q <= D;

endmodule