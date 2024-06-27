module register_set #(
    parameter W = 8 
)
(
    input               clk   ,
    input               set   ,
    input               ce    ,
    input      [W-1:0]  d     ,
    output reg [W-1:0]  q
);

always @(posedge clk)
    if (set)
        q <= {W{1'b1}};
    else if (ce)    
        q <= d;

endmodule