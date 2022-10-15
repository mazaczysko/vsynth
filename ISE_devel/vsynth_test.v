module vsynth_test (
	input CLK,
	input DI,
	input	 [3:0] CHANNEL,
	output [3:0] CHANNEL_LED,
	output [7:0] SAMPLE_OUT,
	output [7:0] SEG,
	output [3:0] AN
);

wire dv;
wire [7:0] uart_out;

wire [6:0] NOTE_NUM;
wire [6:0] NOTE_VEL;
wire [6:0] PROGRAM;

assign CHANNEL_LED = CHANNEL;

uart_rx uart (
	.CLK(CLK),
	.CE(1'd1),
	.RST(1'd0),
	.DI(DI),
	.DV(dv),
	.PO(uart_out)
);

midi midi1(
	.CLK(CLK),
	.CE(1'd1),
	.RST(1'd0),
	.CHANNEL(CHANNEL),
	.DATA(uart_out),
	.DV(dv),
	.NOTE_NUM(NOTE_NUM),
	.NOTE_VEL(NOTE_VEL),
	.PROGRAM(PROGRAM)
);

nco osc (
	.CLK(CLK),
	.CE(1'd1),
	.NOTE_NUM(NOTE_NUM),
	.NOTE_VEL(NOTE_VEL),
	.PROGRAM(PROGRAM),
	.SAMPLE_OUT(SAMPLE_OUT)
);

seg_8bit disp (
	.CLK(CLK),
	.CE(1'd1),
	.BIN_IN(PROGRAM),
	.SEG(SEG),
	.AN(AN)
);

endmodule