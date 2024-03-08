module prescaler #(
    parameter MODULO = 100000000,
    parameter W = 27
    
)
(
    input CLK,
    input CE,
    output CEO
);

reg [W-1:0] Q = 0;

always @(posedge CLK)
    if (CE)
        if (Q == MODULO-1)
            Q <= {W{1'd0}};
        else
            Q <= Q+1;     

    assign CEO = CE & (Q == MODULO-1);
    
endmodule