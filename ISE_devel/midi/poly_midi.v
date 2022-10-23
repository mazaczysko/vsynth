module poly_midi(
	input 			CLK,
	input 			CE,
	input 			RST,
	input  [3:0]	CHANNEL,
	input  [7:0]	DATA,
	input 			DV,
	output [6:0] PROGRAM,
	output [6:0] NOTE_NUM_0,
	output [6:0] NOTE_NUM_1,
	output [6:0] NOTE_NUM_2,
	output [6:0] NOTE_NUM_3,
	output [6:0] NOTE_VEL_0,
	output [6:0] NOTE_VEL_1,
	output [6:0] NOTE_VEL_2,
	output [6:0] NOTE_VEL_3
);


wire note_off_out;
wire note_on_out;

wire [6:0] note_num_out;
wire [6:0] note_vel_out;

midi interprter(
    .CLK(CLK),
    .CE(CE),
    .RST(RST),
    .CHANNEL(CHANNEL),
    .DATA(DATA),
    .DV(DV),
    .NOTE_NUM(note_num_out),
    .NOTE_VEL(note_vel_out),
    .PROGRAM(PROGRAM),
    .NOTE_ON_OUT(note_on_out),
    .NOTE_OFF_OUT(note_off_out)
);

polyphony poly(
    .CLK(CLK),
    .CE(CE),
    .RST(RST),
    .NOTE_NUM(note_num_out),
    .NOTE_VEL(note_vel_out),
    .NOTE_ON(note_on_out),
    .NOTE_OFF(note_off_out),
    .NOTE_NUM_0(NOTE_NUM_0),
    .NOTE_NUM_1(NOTE_NUM_1),
    .NOTE_NUM_2(NOTE_NUM_2),
    .NOTE_NUM_3(NOTE_NUM_3),
    .NOTE_VEL_0(NOTE_VEL_0),
    .NOTE_VEL_1(NOTE_VEL_1),
    .NOTE_VEL_2(NOTE_VEL_2),
    .NOTE_VEL_3(NOTE_VEL_3)
);

endmodule
