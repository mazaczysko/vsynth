//64 Samples in wave and wave mirroring

module phase2sample ( 
    input CLK,
    input CE,           //Sample rate 
    input [6:0] PHASE,
    input [6:0] PROGRAM,
    output [7:0] SAMPLE
);

wire half_select;
assign half_select = PHASE[6];

wire [5:0] half_phase;
assign half_phase = PHASE[5:0];

wire [5:0] phase;
assign phase = half_select ? 6'd63 - half_phase : half_phase;

wire [7:0] sample;
assign SAMPLE = half_select ? 8'd255 - sample : sample;

sample_rom rom (
	.CLK(CLK),
	.CE(CE),
	.A0(phase), //phase_reg_out[15:9]
	.A1(PROGRAM),
	.D(sample)
);

endmodule