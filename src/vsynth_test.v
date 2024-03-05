module vsynth_test (
	input CLK,
	input DI,
	input  [3:0] CHANNEL,
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

wire [6:0] note_num_0;
wire [6:0] note_num_1;
wire [6:0] note_num_2;
wire [6:0] note_num_3;

wire [6:0] note_vel_0;
wire [6:0] note_vel_1;
wire [6:0] note_vel_2;
wire [6:0] note_vel_3;

assign CHANNEL_LED = CHANNEL;

uart_rx uart (
	.CLK(CLK),
	.CE(1'd1),
	.RST(1'd0),
	.DI(DI),
	.DV(dv),
	.PO(uart_out)
);

poly_midi midi_interpreter(
	.CLK(CLK),
	.CE(1'd1),
	.RST(1'd0),
	.CHANNEL(CHANNEL),
	.DATA(uart_out),
	.DV(dv),
	.PROGRAM(PROGRAM),
	.NOTE_NUM_0(note_num_0),
    .NOTE_NUM_1(note_num_1),
    .NOTE_NUM_2(note_num_2),
    .NOTE_NUM_3(note_num_3),
    .NOTE_VEL_0(note_vel_0),
    .NOTE_VEL_1(note_vel_1),
    .NOTE_VEL_2(note_vel_2),
    .NOTE_VEL_3(note_vel_3)
);

nco_bank voice (
	.CLK(CLK),
	.CE(1'd1),
	.RST(1'b0),
	.PROGRAM(PROGRAM),
	.NOTE_NUM_0(note_num_0),
    .NOTE_NUM_1(note_num_1),
    .NOTE_NUM_2(note_num_2),
    .NOTE_NUM_3(note_num_3),
    .NOTE_VEL_0(note_vel_0),
    .NOTE_VEL_1(note_vel_1),
    .NOTE_VEL_2(note_vel_2),
    .NOTE_VEL_3(note_vel_3),	
	.SAMPLE_SUM_OUT(SAMPLE_OUT)
);

seg_8bit disp (
	.CLK(CLK),
	.CE(1'd1),
	.BIN_IN(PROGRAM),
	.SEG(SEG),
	.AN(AN)
);

endmodule