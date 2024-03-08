module shift_reg #(
    parameter W = 8
)
(
    input               CLK,
    input               CE,
    input               CLR,
    input               DIR, //1 - right, 0 - left
    input               D,
    output reg [W-1:0]  Q = 0
);

always @(posedge CLK)
    if (CLR)
        Q <= {W{1'd0}};
    else if(CE)
        if( DIR )
            Q <= {D,Q[W-1:1]};
        else
            Q <= {Q[W-2:0],D};

endmodule