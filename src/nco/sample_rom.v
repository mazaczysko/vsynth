module sample_rom (
	input            clk    ,
	input            ce     ,
	input      [5:0] sample ,
	input 	   [6:0] prog   ,
	output reg [7:0] d
);

localparam WFM_CNT = 256;
localparam SAMPLES_PER_WFM = 64;

(* rom_style="block" *)
reg [7:0] sample_rom [WFM_CNT*SAMPLES_PER_WFM-1:0];

initial
	$readmemh("sample_rom.mem", sample_rom, 0, WFM_CNT*SAMPLES_PER_WFM-1 );

always @(posedge clk)
	if (ce)
    	d <= sample_rom[{prog, sample}];

endmodule
