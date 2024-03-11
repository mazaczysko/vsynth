module bcd7seg (
	input 				clk	,
	input 				ce	,
	input 		[3:0]   bcd	,
	output reg 	[7:0]	seg
);

always @(posedge clk)
	if (ce)
		case (bcd)
			4'd0 : seg <= 8'b00000011; 
            4'd1 : seg <= 8'b10011111; 
            4'd2 : seg <= 8'b00100101; 
            4'd3 : seg <= 8'b00001101; 
            4'd4 : seg <= 8'b10011001; 
            4'd5 : seg <= 8'b01001001; 
            4'd6 : seg <= 8'b01000001; 
            4'd7 : seg <= 8'b00011111; 
            4'd8 : seg <= 8'b00000001; 
        	4'd9 : seg <= 8'b00001001; 
			default: seg <= 8'b11111111;
		endcase

endmodule