`timescale 1ns / 1ps
module nco_tb;

reg CLK;
reg CE;
reg [6:0] NOTE_NUM;
reg [6:0] NOTE_VEL;
reg [6:0] PROGRAM;
wire [7:0] SAMPLE_OUT;


initial begin
    CLK = 0;
    CE = 1;
    NOTE_NUM = 50;
    NOTE_VEL = 127;
    PROGRAM = 1;
end

always #1 CLK = ~CLK; 

nco osc (
    .CLK(CLK),
    .CE(CE),
    .NOTE_NUM(NOTE_NUM),
    .NOTE_VEL(NOTE_VEL),
    .PROGRAM(PROGRAM),
    .SAMPLE_OUT(SAMPLE_OUT)
);

initial begin
    #10000000 NOTE_VEL = 64;
    #10000000 NOTE_VEL = 20;
    
    
end


endmodule