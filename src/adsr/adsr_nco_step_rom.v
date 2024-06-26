module adsr_nco_step_rom (
    input             clk  ,
    input             re   ,
    input       [6:0] addr ,
    output reg [18:0] data
);

localparam ROM_SIZE = 128;

(* rom_style="block" *)
reg [18:0] step_size_rom [ROM_SIZE-1:0];

initial
    $readmemh("C:/Users/mrygula/Desktop/vsynth/src/adsr/adsr_nco_step_rom.mem", step_size_rom, 0, ROM_SIZE-1 );

always @(posedge clk)
    if (re)
            data <= step_size_rom[addr];

endmodule