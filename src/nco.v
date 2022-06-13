module nco (
	input CLK,
	input [6:0] NOTE_NUM,
	input [6:0] PROGRAM,
	output[7:0] LED,
	output[7:0] SAMPLE_OUT
);

parameter CE = 1;

wire trig_sample;
wire [7:0] sample_out;

assign SAMPLE_OUT = sample_out;
assign LED = sample_out;

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


step_size_rom rom1 (
	.CLK(CLK),
	.CE(CE),
	.A(NOTE_NUM),
	.D(step)
);

sample_rom rom2 (
	.CLK(CLK),
	.CE(trig_sample),
	.A0(phase_reg_out[15:9]),
	.A1(PROGRAM),
	.D(sample_out)
);

endmodule
