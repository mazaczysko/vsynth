module shift_reg_right #(
    parameter W = 8
)
(
    input               clk,
    input               ce,
    input               clr,
    input               d,
    output reg [W-1:0]  q = 0
);

always @(posedge clk)
    if (clr)
        q <= {W{1'd0}};
    else if(ce)
        q <= {d,q[W-1:1]};

endmodule