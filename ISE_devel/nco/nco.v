module nco (
	input CLK,
	input CE,
	input TRIG_READ,
	input [15:0] STEP_SIZE, //input of phase adder
	input [6:0] NOTE_VEL,
	input [7:0] PROG_SAMPLE,
	output [7:0] PHASE,
	output reg [7:0] SAMPLE_OUT
);

//parameter CE = 1;

wire trig_sample;
wire [7:0] sample_out;
wire [7:0] sample;

wire [15:0] sample_vel;

assign sample_vel = PROG_SAMPLE * NOTE_VEL;

assign SAMPLE_OUT = sample_vel[14:7];

assign PHASE  = phase_reg_out[15:9];

//assign SAMPLE_OUT = sample_out;

wire [15:0] phase_add_out;  //output of phase adder
wire [15:0] phase_reg_out;  //input of phase adder

assign phase_add_out = phase_reg_out + step;

register #(
    .W(16)
)
phase_reg
(
    .CLK(CLK),
    .CE(TRIG_SAMPLE),
    .D(phase_add_out),
    .Q(phase_reg_out)
);


endmodule
