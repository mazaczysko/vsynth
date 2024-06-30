module wavetable_offset_rom (
    input            clk    ,
    input            re     ,
    input      [4:0] addr   ,
    output reg [9:0] data
);

localparam ROM_SIZE = 29;

(* rom_style="block" *)
reg [9:0] wavetable_offset_rom [ROM_SIZE-1:0];

initial
    $readmemh("C:/Users/mrygula/Desktop/vsynth/src/wavetables/wavetable_offset_rom.mem", wavetable_offset_rom, 0, ROM_SIZE-1 );

always @(posedge clk)
    if (re)
        data <= wavetable_offset_rom[addr];

endmodule
