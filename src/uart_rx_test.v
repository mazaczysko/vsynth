module uart_rx_test (
    input 			 clk    ,
    input 			 di		,
    output reg [7:0] po = 0
);

wire dv;

wire [7:0] uart_out;

uart_rx uart (
    .clk ( clk		),
    .ce  ( 1'd1		),
    .rst ( 1'd0		),
    .di  ( di		),
    .dv  ( dv		),
    .po  ( uart_out	)
);

always @(posedge clk)
    if (dv)
        po <= uart_out;
        

endmodule