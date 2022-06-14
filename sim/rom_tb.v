`timescale 1ns / 1ps

module rom_tb;

reg CLK;
reg CE;
reg [6:0] NOTE_NUM;
reg [6:0] phase;
reg [6:0] PROGRAM;

//wire [6:0] phase;
wire [15:0] step;
wire [7:0] SAMPLE_OUT;

step_size_rom rom1(
    .CLK(CLK),
    .CE(CE),
    .A(NOTE_NUM),
    .D(step)
);

sample_rom rom2(
    .CLK(CLK),
    .CE(CE),
    .A0(phase),
    .A1(PROGRAM),
    .D(SAMPLE_OUT)
);

/*
up_cnt_mod #(
    .MODULO(128),
    .W(7)
)
phase_cnt
(
    .CLK(CLK),
    .CE(1'd1),
    .Q(phase)
);
*/

initial begin
    CE = 1;
    CLK = 0;
    NOTE_NUM = 0;
    phase = 0;
    PROGRAM = 0;
end

always #5 CLK = ~CLK;

initial begin
/*
    #30 NOTE_NUM = 1;
    phase = 2;
    #30 NOTE_NUM = 2;
    phase = 10;
    #30 NOTE_NUM = 3;
    phase = 64;
    #30 NOTE_NUM = 127;
    phase = 127;
    #30 NOTE_NUM = 0;
    PROGRAM = 1;
    phase = 0;
    #30 phase = 64;
    #30 phase = 127;
*/

    //#3810 PROGRAM = 1;
    //#3810 PROGRAM = 2;
    
    #30 phase = 127;
    #30 PROGRAM = 1;
    phase = 0;
    #30 phase = 127;
    #30 PROGRAM = 2;
    phase = 0;
    #30 phase = 127;

    
end

endmodule