module prescaler #(
    parameter MODULO = 100000000,
    parameter W = 27
    
)
(
    input  clk ,
    input  ce  ,
    output ceo
);

reg [W-1:0] q = 0;

always @(posedge clk)
    if (ce)
        if (q == MODULO-1)
            q <= {W{1'd0}};
        else
            q <= q+1;     

    assign ceo = ce & (q == MODULO-1);
    
endmodule