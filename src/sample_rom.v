module sample_rom (
	input CLK,
	input CE,
	input [5:0] A0,
	input [6:0] A1,
	output reg [7:0] D
);

   	reg [7:0] sample_rom [(2**13)-1:0];
   
   	initial
		$readmemh("sample_rom.mem", sample_rom );

   	always @(posedge CLK)
    	if (CE)
        	 D <= sample_rom[{A1,A0}];

endmodule
