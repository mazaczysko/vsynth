module nco (
	input CLK,
	//input CE,
	input [6:0] NOTE_NUM,
	//input [6:0] NOTE_VEL,
	//input [6:0] PROGRAM,
	output[7:0] SAMPLE_OUT
);

parameter CE = 1;

wire trig_sample;
wire [7:0] sample_out;
wire [7:0] sample;

assign SAMPLE_OUT = sample_out;

wire [15:0] step;           //input of phase adder
wire [15:0] phase_add_out;  //output of phase adder
wire [15:0] phase_reg_out;  //input of phase adder

//assign phase_add_out = phase_reg_out + step;
assign phase_add_out = phase_reg_out + {16'h385};


//32kHz sample rate @ 100MHz CLK
prescaler #(

	.MODULO(3125),
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
    .CE(trig_sample),
    .PHASE(phase_reg_out[15:9]),
	.PROGRAM(NOTE_NUM),
    .SAMPLE_OUT(sample_out)
);

//Skip volume_rom (ISE error)


endmodule