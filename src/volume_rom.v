module volume_rom (
	input CLK,
	input CE,
	input [7:0] SAMPLE,
	input [6:0] VEL,
	output reg [7:0] SAMPLE_OUT
);

   	reg [7:0] volume_rom [(2**15)-1:0];
   
   	initial
		$readmemh("volume_rom.mem", volume_rom );

   	always @(posedge CLK)
    	if (CE)
        	 SAMPLE_OUT <= volume_rom[{SAMPLE,VEL}];

endmodule
