module step_size_rom (
	input 			  clk ,
	input 			  ce  ,
	input       [6:0] a   ,
	output reg [15:0] d
);

reg [15:0] step_size_rom [127:0];
   
//initial
//	$readmemh("step_size_rom.mem", step_size_rom );

always @(posedge clk)
	if (ce)
			d <= step_size_rom[a];

initial begin
	step_size_rom[0] = 16'd17;
	step_size_rom[1] = 16'd18;
	step_size_rom[2] = 16'd19;
	step_size_rom[3] = 16'd20;
	step_size_rom[4] = 16'd21;
	step_size_rom[5] = 16'd22;
	step_size_rom[6] = 16'd24;
	step_size_rom[7] = 16'd25;
	step_size_rom[8] = 16'd27;
	step_size_rom[9] = 16'd28;
	step_size_rom[10] = 16'd30;
	step_size_rom[11] = 16'd32;
	step_size_rom[12] = 16'd33;
	step_size_rom[13] = 16'd35;
	step_size_rom[14] = 16'd38;
	step_size_rom[15] = 16'd40;
	step_size_rom[16] = 16'd42;
	step_size_rom[17] = 16'd45;
	step_size_rom[18] = 16'd47;
	step_size_rom[19] = 16'd50;
	step_size_rom[20] = 16'd53;
	step_size_rom[21] = 16'd56;
	step_size_rom[22] = 16'd60;
	step_size_rom[23] = 16'd63;
	step_size_rom[24] = 16'd67;
	step_size_rom[25] = 16'd71;
	step_size_rom[26] = 16'd75;
	step_size_rom[27] = 16'd80;
	step_size_rom[28] = 16'd84;
	step_size_rom[29] = 16'd89;
	step_size_rom[30] = 16'd95;
	step_size_rom[31] = 16'd100;
	step_size_rom[32] = 16'd106;
	step_size_rom[33] = 16'd113;
	step_size_rom[34] = 16'd119;
	step_size_rom[35] = 16'd126;
	step_size_rom[36] = 16'd134;
	step_size_rom[37] = 16'd142;
	step_size_rom[38] = 16'd150;
	step_size_rom[39] = 16'd159;
	step_size_rom[40] = 16'd169;
	step_size_rom[41] = 16'd179;
	step_size_rom[42] = 16'd189;
	step_size_rom[43] = 16'd201;
	step_size_rom[44] = 16'd213;
	step_size_rom[45] = 16'd225;
	step_size_rom[46] = 16'd239;
	step_size_rom[47] = 16'd253;
	step_size_rom[48] = 16'd268;
	step_size_rom[49] = 16'd284;
	step_size_rom[50] = 16'd301;
	step_size_rom[51] = 16'd319;
	step_size_rom[52] = 16'd338;
	step_size_rom[53] = 16'd358;
	step_size_rom[54] = 16'd379;
	step_size_rom[55] = 16'd401;
	step_size_rom[56] = 16'd425;
	step_size_rom[57] = 16'd451;
	step_size_rom[58] = 16'd477;
	step_size_rom[59] = 16'd506;
	step_size_rom[60] = 16'd536;
	step_size_rom[61] = 16'd568;
	step_size_rom[62] = 16'd601;
	step_size_rom[63] = 16'd637;
	step_size_rom[64] = 16'd675;
	step_size_rom[65] = 16'd715;
	step_size_rom[66] = 16'd758;
	step_size_rom[67] = 16'd803;
	step_size_rom[68] = 16'd851;
	step_size_rom[69] = 16'd901;
	step_size_rom[70] = 16'd955;
	step_size_rom[71] = 16'd1011;
	step_size_rom[72] = 16'd1072;
	step_size_rom[73] = 16'd1135;
	step_size_rom[74] = 16'd1203;
	step_size_rom[75] = 16'd1274;
	step_size_rom[76] = 16'd1350;
	step_size_rom[77] = 16'd1430;
	step_size_rom[78] = 16'd1515;
	step_size_rom[79] = 16'd1606;
	step_size_rom[80] = 16'd1701;
	step_size_rom[81] = 16'd1802;
	step_size_rom[82] = 16'd1909;
	step_size_rom[83] = 16'd2023;
	step_size_rom[84] = 16'd2143;
	step_size_rom[85] = 16'd2271;
	step_size_rom[86] = 16'd2406;
	step_size_rom[87] = 16'd2549;
	step_size_rom[88] = 16'd2700;
	step_size_rom[89] = 16'd2861;
	step_size_rom[90] = 16'd3031;
	step_size_rom[91] = 16'd3211;
	step_size_rom[92] = 16'd3402;
	step_size_rom[93] = 16'd3604;
	step_size_rom[94] = 16'd3819;
	step_size_rom[95] = 16'd4046;
	step_size_rom[96] = 16'd4286;
	step_size_rom[97] = 16'd4541;
	step_size_rom[98] = 16'd4811;
	step_size_rom[99] = 16'd5098;
	step_size_rom[100] = 16'd5401;
	step_size_rom[101] = 16'd5722;
	step_size_rom[102] = 16'd6062;
	step_size_rom[103] = 16'd6422;
	step_size_rom[104] = 16'd6804;
	step_size_rom[105] = 16'd7209;
	step_size_rom[106] = 16'd7638;
	step_size_rom[107] = 16'd8092;
	step_size_rom[108] = 16'd8573;
	step_size_rom[109] = 16'd9083;
	step_size_rom[110] = 16'd9623;
	step_size_rom[111] = 16'd10195;
	step_size_rom[112] = 16'd10801;
	step_size_rom[113] = 16'd11444;
	step_size_rom[114] = 16'd12124;
	step_size_rom[115] = 16'd12845;
	step_size_rom[116] = 16'd13609;
	step_size_rom[117] = 16'd14418;
	step_size_rom[118] = 16'd15275;
	step_size_rom[119] = 16'd16184;
	step_size_rom[120] = 16'd17146;
	step_size_rom[121] = 16'd18165;
	step_size_rom[122] = 16'd19246;
	step_size_rom[123] = 16'd20390;
	step_size_rom[124] = 16'd21602;
	step_size_rom[125] = 16'd22887;
	step_size_rom[126] = 16'd24248;
	step_size_rom[127] = 16'd25690;
end

endmodule