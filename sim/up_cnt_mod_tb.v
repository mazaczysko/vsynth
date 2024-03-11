`timescale 1ns / 1ps


module up_cnt_mod_tb;

reg clk, ce, rst;
wire co0, co1;
wire [3:0] q0;
wire [3:0] q1;

initial begin
    clk = 0;
    rst = 1;
    ce = 0;
end

always #1 clk = ~clk;

up_cnt_mod #(
    .MODULO(10),
    .W(4)
)
dekada0
(
    .clk(clk),
    .ce(ce),
    .clr(rst),
    .q(q0),
    .co(co0)
);

up_cnt_mod #(
    .MODULO(10),
    .W(4)
)
dekada1
(
    .clk(clk),
    .ce(co0),
    .clr(rst),
    .q(q1),
    .co(co1)
);

initial begin
    #5 ce = 1;
    #5 rst = 0;
    #200 $stop;
end




endmodule
