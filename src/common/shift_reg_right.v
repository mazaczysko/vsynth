module shift_reg_right #(
    parameter W = 8
)
(
    input               CLK,
    input               CE,
    input               CLR,
    input               D,
    output reg [W-1:0]  Q = 0
);

always @(posedge CLK)
    if (CLR)
        Q <= {W{1'd0}};
    else if(CE)
        Q <= {D,Q[W-1:1]};

endmodule