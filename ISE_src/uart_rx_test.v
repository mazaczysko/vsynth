module uart_rx_test (
	input CLK,
	input DI,
	output reg [7:0] PO = 0
);

wire dv;

wire [7:0] uart_out;

uart_rx uart (
	.CLK(CLK),
	.CE(1'd1),
	.RST(1'd0),
	.DI(DI),
	.DV(dv),
	.PO(uart_out)
);

always @(posedge CLK)
	if (dv)
		PO <= uart_out;
		

endmodule