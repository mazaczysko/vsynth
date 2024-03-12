module phase2sample ( 
    input clk,
    input ce,           //Sample rate 
    input [6:0] phase,
    input [6:0] program,
    output reg [7:0] sample_out = 0
);

//64 Samples in wave and wave mirroring

wire half_select;
wire [5:0] half_phase;
wire [5:0] phase;

wire [7:0] sample;
wire [7:0] sample_final;

assign half_select = phase[6];
assign half_phase = phase[5:0];
assign phase = half_select ? 6'd63 - half_phase : half_phase;

assign sample_final = half_select ? 8'd255 - sample : sample;

always @(posedge clk)
	if(ce)
		sample_out <= sample_final;

sample_rom rom (
	.clk	( clk		     ),
	.ce		( ce			 ),
	.sample ( phase			 ), //phase_reg_out[15:9]
	.prog 	( program		 ),
	.d	  	( sample		 )
);

endmodule