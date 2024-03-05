module nco (
	input CLK,
	input CE,
	input TRIG_READ,
	input [15:0] STEP_SIZE, //input of phase adder
	input [6:0] NOTE_VEL,
	input TRIG_SAMPLE,
	input [7:0] PROG_SAMPLE,
	output [6:0] PHASE,
	output [7:0] SAMPLE_OUT
);

wire [7:0] sample;
wire [15:0] sample_vel;
wire [7:0] output_sample = sample_vel[14:7];
assign sample_vel = PROG_SAMPLE * NOTE_VEL;


wire [15:0] phase_add_out;  //output of phase adder
wire [15:0] phase_reg_out;  //input of phase adder


assign PHASE  = phase_reg_out[15:9];
//assign PHASE  = phase_reg_out[7:0]; //for simulation

assign phase_add_out = phase_reg_out + STEP_SIZE;

register #(
    .W(16)
)
phase_reg
(
    .CLK(CLK),
    .CE(TRIG_READ),
    .D(phase_add_out),
    .Q(phase_reg_out)
);

register #(
    .W(8)
)
sample_out_reg
(
    .CLK(CLK),
    .CE(TRIG_SAMPLE),
    .D(output_sample),
    .Q(SAMPLE_OUT)
);


endmodule
