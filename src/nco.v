module nco (
	input CLK,
	input CE,
	input [6:0] NOTE_NUM,
	input [6:0] NOTE_VEL,
	input [6:0] PROGRAM,
	output[7:0] SAMPLE_OUT,
	output TRIG
);


wire trig_sample;
wire [7:0] sample_out;
wire [7:0] sample;

assign SAMPLE_OUT = sample_out;
assign LED = sample_out;
assign TRIG = trig_sample;

wire [15:0] step;           //input of phase adder
wire [15:0] phase_add_out;  //output of phase adder
wire [15:0] phase_reg_out;  //input of phase adder

assign phase_add_out = phase_reg_out + step;


//28kHz sample rate @ 100MHz CLK
prescaler #(

	.MODULO(3571),
	.W(12)
)
sample_rate
(
	.CLK(CLK),
	.CE(1'd1),
	.CEO(trig_sample)
);

register #(
    .W(16)
)
phase_reg
(
    .CLK(CLK),
    .CE(trig_sample),
    .D(phase_add_out),
    .Q(phase_reg_out)
);


step_size_rom step_rom (
	.CLK(CLK),
	.CE(CE),
	.A(NOTE_NUM),
	.D(step)
);

phase2sample sampler( 
    .CLK(CLK),
    .CE(CE),
    .PHASE(phase_reg_out[15:9]),
    .PROGRAM(PROGRAM),
    .SAMPLE(sample_out)
);


volume_rom vel_rom (
	.CLK(CLK),
	.CE(CE),
	.SAMPLE(sample),
	.VEL(NOTE_VEL),
	.SAMPLE_OUT(sample) //Disabled
);


endmodule
