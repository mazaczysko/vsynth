module wavetable_data_rom (
	input            clk    ,
	input            re     ,
    input            addr   ,
	output reg [7:0] data
);

localparam ROM_SIZE = 641;

(* rom_style="block" *)
reg [7:0] wavetable_data_rom [ROM_SIZE-1:0];

initial
	$readmemh("wavetable_data_rom.mem", wavetable_data_rom, 0, ROM_SIZE-1 );

always @(posedge clk)
	if (ce)
    	data <= wavetable_data_rom[addr];

endmodule
