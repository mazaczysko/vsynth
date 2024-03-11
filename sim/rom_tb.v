`timescale 1ns / 1ps

module rom_tb;

reg clk;
reg ce;
reg [6:0] note_num;
reg [6:0] phase;
reg [6:0] program;

//wire [6:0] phase;
wire [15:0] step;
wire [7:0] sample_out;

step_size_rom rom1(
    .clk(clk),
    .ce(ce),
    .a(note_num),
    .d(step)
);

sample_rom rom2(
    .clk(clk),
    .ce(ce),
    .A0(phase),
    .A1(program),
    .D(sample_out)
);

/*
up_cnt_mod #(
    .MODULO(128),
    .W(7)
)
phase_cnt
(
    .clk(clk),
    .ce(1'd1),
    .Q(phase)
);
*/

initial begin
    ce = 1;
    clk = 0;
    note_num = 0;
    phase = 0;
    program = 0;
end

always #5 clk = ~clk;

initial begin
/*
    #30 note_num = 1;
    phase = 2;
    #30 note_num = 2;
    phase = 10;
    #30 note_num = 3;
    phase = 64;
    #30 note_num = 127;
    phase = 127;
    #30 note_num = 0;
    program = 1;
    phase = 0;
    #30 phase = 64;
    #30 phase = 127;
*/

    //#3810 program = 1;
    //#3810 program = 2;
    
    #30 phase = 127;
    #30 program = 1;
    phase = 0;
    #30 phase = 127;
    #30 program = 2;
    phase = 0;
    #30 phase = 127;

    
end

endmodule