module midi_test (
	input CLK,
	input DI,
	output [2:0] NOTE,
	output [2:0] VEL,
	output [1:0] PROG,
	output [7:0] SAMPLE_OUT
);

wire dv;
wire [7:0] uart_out;

wire [6:0] NOTE_NUM;
wire [6:0] NOTE_VEL;
wire [6:0] PROGRAM;

assign NOTE = NOTE_NUM[2:0];
assign VEL = NOTE_VEL[2:0];
assign PROG = PROGRAM[1:0];

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
	.data(uart_out),
	.dv(dv),
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

endmodule