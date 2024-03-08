module up_cnt_mod #(  
    parameter MODULO = 10,
    parameter W = 4 
)
(
    input               CLK,
    input               CE,
    input               CLR,
    output reg [W-1:0]  Q = 0,
    output              CO
);

always @(posedge CLK)
    if (CLR)
        Q <= {W{1'd0}};
    else if (CE)
        if (Q == MODULO-1)
            Q <= {W{1'd0}};
        else
            Q <= Q+1;
            
    assign CO = CE & (Q == MODULO-1);

endmodule