module step_size_rom (
	input 			  clk  ,
	input 			  re   ,
	input       [6:0] addr ,
	output reg [15:0] data
);

localparam ROM_SIZE = 128;

(* rom_style="block" *)
reg [15:0] step_size_rom [ROM_SIZE-1:0];

initial
	$readmemh("step_size_rom.mem", step_size_rom, 0, ROM_SIZE-1 );

always @(posedge clk)
	if (ce)
			data <= step_size_rom[addr];

endmodule