//64 Samples in wave and wave mirroring

module phase2sample ( 
    input CLK,
    input CE,           //Sample rate 
    input [6:0] PHASE,
    input [6:0] PROGRAM,
    output reg [7:0] SAMPLE_OUT = 0
);

wire half_select;
assign half_select = PHASE[6];

wire [5:0] half_phase;
assign half_phase = PHASE[5:0];

wire [5:0] phase;
assign phase = half_select ? 6'd63 - half_phase : half_phase;

wire [7:0] sample;
wire [7:0] sample_final;
assign sample_final = half_select ? 8'd255 - sample : sample;

always @(posedge CLK)
	if(CE)
		SAMPLE_OUT <= sample_final;

sample_rom rom (
	.CLK(CLK),
	.CE(CE),
	.SAMPLE(phase), //phase_reg_out[15:9]
	.PROG({1'd0,PROGRAM}), //IMPORTANT TO FIX!!!!!!
	.D(sample)
);

endmodule