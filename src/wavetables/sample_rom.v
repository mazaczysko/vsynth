module sample_rom (
    input            clk            ,
    input            re_a           ,
    input      [5:0] addr_a_sample 	,
    input      [7:0] addr_a_wfm   	,
    output reg [7:0] data_a         ,
    input            re_b     	   	,
    input      [5:0] addr_b_sample 	,
    input      [7:0] addr_b_wfm   	,
    output reg [7:0] data_b        
);

localparam WFM_CNT = 256;
localparam SAMPLES_PER_WFM = 64;

(* rom_style="block" *)
reg [7:0] sample_rom [WFM_CNT*SAMPLES_PER_WFM-1:0];

initial
    $readmemh("C:/Users/mrygula/Desktop/vsynth/src/wavetables/sample_rom.mem", sample_rom, 0, WFM_CNT*SAMPLES_PER_WFM-1 );

always @(posedge clk)
    if (re_a)
        data_a <= sample_rom[{addr_a_wfm, addr_a_sample}];

always @(posedge clk)
    if (re_b)
        data_b <= sample_rom[{addr_b_wfm, addr_b_sample}];

endmodule
