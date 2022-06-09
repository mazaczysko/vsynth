`timescale 1ns / 1ps



module up_cnt_mod #(  
    parameter MODULO = 3200,
    parameter W = 12 
)
(
    input               CLK,
    input               CE,
    input               CLR,
    output reg [W-1:0]  Q,
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

module shift_reg #(
    parameter W = 8
)
(
    input               CLK,
    input               CE,
    input               CLR,
    input               DIR, //1 - right, 0 - left
    input               D,
    output reg [W-1:0]  Q
);

always @(posedge CLK)
    if (CLR)
        Q <= {W{1'd0}};
    else if(CE)
        if( DIR )
            Q <= {D,Q[7:1]};
        else
            Q <= {Q[6:0],D};


endmodule
