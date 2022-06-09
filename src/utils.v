`timescale 1ns / 1ps



module up_cnt_mod
#(  parameter MODULO = 3200,
    parameter W = 12 
)
(
    input             CLK,
    input             CLR,
    input             CE,
    output reg [W-1:0]  Q,
    output          CO
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
