module step_size_rom (
	input 			  clk ,
	input 			  ce  ,
	input       [6:0] a   ,
	output reg [15:0] d
);

(* rom_style="block" *)
reg [15:0] step_size_rom [127:0];

initial
	$readmemh("step_size_rom.mem", step_size_rom );

always @(posedge clk)
	if (ce)
			d <= step_size_rom[a];

endmodule