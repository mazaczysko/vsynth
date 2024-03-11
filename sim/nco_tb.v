`timescale 1ns / 1ps
module nco_tb;

reg clk;
reg ce;
reg [6:0] note_num;
reg [6:0] note_vel;
reg [6:0] program;
wire [7:0] sample_out;


initial begin
    clk = 0;
    ce = 1;
    note_num = 0;
    note_vel = 127;
    program = 1;
end

always #1 clk = ~clk; 

nco osc (
    .clk(clk),
    .ce(ce),
    .note_num(note_num),
    .note_vel(note_vel),
    .program(program),
    .sample_out(sample_out)
);

initial begin
    #10000000 note_vel = 64;
    #10000000 note_vel = 20;
end


endmodule