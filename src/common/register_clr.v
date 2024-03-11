module register_clr #(
    parameter W = 8 
)
(
    input               clk   ,
    input               ce    ,
    input               clr   ,
    input      [W-1:0]  d     ,
    output reg [W-1:0]  q = 0
);

always @(posedge clk)
    if (clr)
        q <= {W{1'd0}};
    else if (ce)    
        q <= d;

endmodule