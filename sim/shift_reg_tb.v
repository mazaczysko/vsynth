`timescale 1ns / 1ps

module shift_reg_tb;

reg clk, ce, rst, d, dir;
wire [7:0] q;

initial begin
    clk = 0;
    rst = 1;
    ce = 0;
    d = 1;
    dir = 1;
end

always #1 clk = ~clk;

shift_reg #(
    .W(8)
)
shift_reg
(
    .clk(clk),
    .ce(ce),
    .CLR(rst),
    .dir(dir),
    .d(d),
    .q(q)
);


initial begin
    #6 ce = 1;
    #6 rst = 0;
    #4 ce = 0;
    d = 0;
    #2 ce = 1;
    #10 d = 1;
    dir = 0;
    #16 d = 0;
    dir = 1;
    #50 $stop;
end

endmodule