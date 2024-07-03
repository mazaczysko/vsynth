module normalized_distance_rom (
    input             clk    ,
    input             re     ,
    input      [7:0]  addr   ,
    output reg [15:0] data
);

localparam ROM_SIZE = 256;

(* rom_style="block" *)
reg [15:0] normalized_distance_rom [ROM_SIZE-1:0];

initial
    $readmemh("C:/Users/mrygula/Desktop/vsynth/src/wavetables/normalized_distance_rom.mem", normalized_distance_rom, 0, ROM_SIZE-1 );

always @(posedge clk)
    if (re)
        data <= normalized_distance_rom[addr];

endmodule
