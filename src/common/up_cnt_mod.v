module up_cnt_mod #(  
    parameter MODULO = 10,
    parameter W = 4 
)
(
    input               clk   ,
    input               ce    ,
    input               clr   ,
    output reg [W-1:0]  q = 0 ,
    output              co
);

always @(posedge clk)
    if (clr)
        q <= {W{1'd0}};
    else if (ce)
        if (q == MODULO-1)
            q <= {W{1'd0}};
        else
            q <= q+1;
            
    assign co = ce & (q == MODULO-1);

endmodule