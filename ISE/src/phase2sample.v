//64 Samples in wave and wave mirroring

module phase2sample ( 
    input CLK,
    input CE,           //Sample rate 
    input [6:0] PHASE,
    //input [6:0] PROGRAM,
    output reg [7:0] SAMPLE_OUT = 0
);

wire half_select;
assign half_select = PHASE[6];

wire [5:0] half_phase;
assign half_phase = PHASE[5:0];

wire [5:0] phase;
assign phase = half_select ? 6'd63 - half_phase : half_phase;

wire [7:0] sample;
reg [7:0] SAMPLE = 0;
wire [7:0] sample_final;
assign sample_final = half_select ? 8'd255 - SAMPLE : SAMPLE;

always @(posedge CLK)
	if(CE)
		SAMPLE_OUT <= sample_final;

always @(posedge CLK)
	if (CE)
		case (phase)
6'd0: SAMPLE <= 8'h00;
6'd1: SAMPLE <= 8'h02;
6'd2: SAMPLE <= 8'h04;
6'd3: SAMPLE <= 8'h06;
6'd4: SAMPLE <= 8'h08;
6'd5: SAMPLE <= 8'h0a;
6'd6: SAMPLE <= 8'h0c;
6'd7: SAMPLE <= 8'h0e;
6'd8: SAMPLE <= 8'h10;
6'd9: SAMPLE <= 8'h12;
6'd10: SAMPLE <= 8'h14;
6'd11: SAMPLE <= 8'h16;
6'd12: SAMPLE <= 8'h18;
6'd13: SAMPLE <= 8'h1a;
6'd14: SAMPLE <= 8'h1c;
6'd15: SAMPLE <= 8'h1e;
6'd16: SAMPLE <= 8'h20;
6'd17: SAMPLE <= 8'h22;
6'd18: SAMPLE <= 8'h24;
6'd19: SAMPLE <= 8'h26;
6'd20: SAMPLE <= 8'h28;
6'd21: SAMPLE <= 8'h2a;
6'd22: SAMPLE <= 8'h2c;
6'd23: SAMPLE <= 8'h2e;
6'd24: SAMPLE <= 8'h30;
6'd25: SAMPLE <= 8'h32;
6'd26: SAMPLE <= 8'h34;
6'd27: SAMPLE <= 8'h36;
6'd28: SAMPLE <= 8'h38;
6'd29: SAMPLE <= 8'h3a;
6'd30: SAMPLE <= 8'h3c;
6'd31: SAMPLE <= 8'h3e;
6'd32: SAMPLE <= 8'h40;
6'd33: SAMPLE <= 8'h42;
6'd34: SAMPLE <= 8'h44;
6'd35: SAMPLE <= 8'h46;
6'd36: SAMPLE <= 8'h48;
6'd37: SAMPLE <= 8'h4a;
6'd38: SAMPLE <= 8'h4c;
6'd39: SAMPLE <= 8'h4e;
6'd40: SAMPLE <= 8'h50;
6'd41: SAMPLE <= 8'h52;
6'd42: SAMPLE <= 8'h54;
6'd43: SAMPLE <= 8'h56;
6'd44: SAMPLE <= 8'h58;
6'd45: SAMPLE <= 8'h5a;
6'd46: SAMPLE <= 8'h5c;
6'd47: SAMPLE <= 8'h5e;
6'd48: SAMPLE <= 8'h60;
6'd49: SAMPLE <= 8'h62;
6'd50: SAMPLE <= 8'h64;
6'd51: SAMPLE <= 8'h66;
6'd52: SAMPLE <= 8'h68;
6'd53: SAMPLE <= 8'h6a;
6'd54: SAMPLE <= 8'h6c;
6'd55: SAMPLE <= 8'h6e;
6'd56: SAMPLE <= 8'h70;
6'd57: SAMPLE <= 8'h72;
6'd58: SAMPLE <= 8'h74;
6'd59: SAMPLE <= 8'h76;
6'd60: SAMPLE <= 8'h78;
6'd61: SAMPLE <= 8'h7a;
6'd62: SAMPLE <= 8'h7c;
6'd63: SAMPLE <= 8'h7e;
		endcase
/*
sample_rom rom (
	.CLK(CLK),
	.CE(CE),
	.A0(phase), //phase_reg_out[15:9]
	.A1(PROGRAM),
	.D(sample)
);
*/
endmodule