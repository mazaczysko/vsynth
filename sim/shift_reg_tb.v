`timescale 1ns / 1ps

module shift_reg_tb;

reg CLK, CE, RST, D, DIR;
wire [7:0] Q;

initial begin
    CLK = 0;
    RST = 1;
    CE = 0;
    D = 1;
    DIR = 1;
end

always #1 CLK = ~CLK;

shift_reg #(
    .W(8)
)
shift_reg
(
    .CLK(CLK),
    .CE(CE),
    .CLR(RST),
    .DIR(DIR),
    .D(D),
    .Q(Q)
);


initial begin
    #6 CE = 1;
    #6 RST = 0;
    #4 CE = 0;
    D = 0;
    #2 CE = 1;
    #10 D = 1;
    DIR = 0;
    #16 D = 0;
    DIR = 1;
    #50 $stop;
end

endmodule