module up_cnt_mod_load #(  
    parameter MODULO = 10,
    parameter W = 4 
)
(
    input               clk     ,
    input               ce      ,
    input               load    ,
    input      [W-1:0]  ld_data ,
    output reg [W-1:0]  q = 0   ,
    output              co     
);

always @(posedge clk)
    if (load)
        q <= (ld_data <= MODULO-1 ? ld_data : MODULO-1);
    else if (ce)
        if (q == MODULO-1)
            q <= {W{1'd0}};
        else
            q <= q+1;
            
    assign co = ce & (q == MODULO-1);

endmodule