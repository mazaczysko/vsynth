module wavetable_data_rom (
    input            clk    ,
    input            re_a   ,
    input      [9:0] addr_a ,
    output reg [7:0] data_a ,
    input            re_b   ,
    input      [9:0] addr_b ,
    output reg [7:0] data_b
);

localparam ROM_SIZE = 641;

(* rom_style="block" *)
reg [7:0] wavetable_data_rom [ROM_SIZE-1:0];

initial
    $readmemh("wavetable_data_rom.mem", wavetable_data_rom, 0, ROM_SIZE-1 );

always @(posedge clk)
    if (re_a)
        data_a <= wavetable_data_rom[addr_a];

always @(posedge clk)
    if (re_b)
        data_b <= wavetable_data_rom[addr_b];

endmodule
