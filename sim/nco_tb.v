`timescale 1ns / 1ps
module nco_tb;

reg CLK;
reg CE;
reg [6:0] NOTE_NUM;
reg [6:0] PROGRAM;
wire [7:0] SAMPLE_OUT;


initial begin
    CLK = 0;
    CE = 1;
    NOTE_NUM = 10;
    PROGRAM = 1;
end

always #1 CLK = ~CLK; 

nco osc (
    .CLK(CLK),
    .NOTE_NUM(NOTE_NUM),
    .PROGRAM(PROGRAM),
    .SAMPLE_OUT(SAMPLE_OUT)
);

initial begin
    #14000000 NOTE_NUM = 50;
    #10000000 PROGRAM = 0;
    #10000000 PROGRAM = 2;
    #5000000 NOTE_NUM = 55 ;
    
    
end


endmodule