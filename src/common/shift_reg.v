module shift_reg #(
    parameter W = 8
)
(
    input               clk   ,
    input               ce    ,
    input               clr   ,
    input               dir   , //1 - right, 0 - left
    input               d     ,
    output reg [W-1:0]  q = 0
);

always @(posedge clk)
    if (clr)
        q <= {W{1'd0}};
    else if(ce)
        if( dir )
            q <= {d,q[W-1:1]};
        else
            q <= {q[W-2:0],d};

endmodule