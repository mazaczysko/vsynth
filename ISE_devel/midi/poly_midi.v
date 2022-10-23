module poly_midi(
	input 			CLK,
	input 			CE,
	input 			RST,
	input  [3:0]	CHANNEL,
	input  [7:0]	DATA,
	input 			DV,
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
wire [6:0] program_out;

wire [6:0] note_num_0_out;
wire [6:0] note_num_1_out;
wire [6:0] note_num_2_out;
wire [6:0] note_num_3_out;

wire [6:0] note_vel_0_out;
wire [6:0] note_vel_1_out;
wire [6:0] note_vel_2_out;
wire [6:0] note_vel_3_out;


midi interprter(
    .CLK(CLK),
    .CE(CE),
    .RST(RST),
    .CHANNEL(CHANNEL),
    .DATA(DATA),
    .DV(DV),
    .NOTE_NUM(note_num_out),
    .NOTE_VEL(note_vel_out),
    .PROGRAM(program_out),
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
    .NOTE_NUM_0(note_num_0_out),
    .NOTE_NUM_1(note_num_1_out),
    .NOTE_NUM_2(note_num_2_out),
    .NOTE_NUM_3(note_num_3_out),
    .NOTE_VEL_0(note_vel_0_out),
    .NOTE_VEL_1(note_vel_1_out),
    .NOTE_VEL_2(note_vel_2_out),
    .NOTE_VEL_3(note_vel_3_out)
);

endmodule
