module nco (
	input CLK,
	input [6:0] NOTE_NUM,
	output[7:0] OUTPUT
);

wire trig_sample;

wire [15:0] step;

prescaler #(

	.MODULO(100000000),
	.W(27)
)
test_prescaler
(
	.CLK(CLK),
	.CE(1'd1),
	.CEO(trig_sample)
);

step_size_rom rom1 (
	.CLK(CLK),
	.CE(trig_sample),
	.A(NOTE_NUM),
	.D(step)
);

sample_rom rom2 (
	.CLK(CLK),
	.CE(trig_sample),
	.A0(NOTE_NUM),
	.A1(7'd0),
	.D(OUTPUT)
);

endmodule
