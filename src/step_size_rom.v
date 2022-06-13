module step_size_rom (
	input CLK,
	input CE,
	input [6:0] A,
	output reg [15:0] D
);

	//(* rom_style = block *)
   	reg [15:0] step_size_rom [127:0];
   
   	initial
		$readmemh("step_size_rom.mem", step_size_rom );

   	always @(posedge CLK)
    	if (CE)
        	 D <= step_size_rom[A];

endmodule