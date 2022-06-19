`timescale 1ns / 1ps


module up_cnt_mod_tb;

reg CLK, CE, RST;
wire CO0, CO1;
wire [3:0] Q0;
wire [3:0] Q1;

initial begin
    CLK = 0;
    RST = 1;
    CE = 0;
end

always #1 CLK = ~CLK;

up_cnt_mod #(
    .MODULO(10),
    .W(4)
)
dekada0
(
    .CLK(CLK),
    .CE(CE),
    .CLR(RST),
    .Q(Q0),
    .CO(CO0)
);

up_cnt_mod #(
    .MODULO(10),
    .W(4)
)
dekada1
(
    .CLK(CLK),
    .CE(CO0),
    .CLR(RST),
    .Q(Q1),
    .CO(CO1)
);

initial begin
    #5 CE = 1;
    #5 RST = 0;
    #200 $stop;
end




endmodule
