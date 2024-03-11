`timescale 1ns / 1ps

module uart_rx_tb;

reg clk, ce, rst, di;
wire dv;
wire [7:0] po;

initial begin
    clk = 0;
    rst = 1;
    ce = 0;
    di = 1;
end

always #1 clk = ~clk;

uart_rx #(
    .CLKS_PER_BIT(50),
    .CLKS_PER_BIT_W(6)
)
uart_receiver
(
    .clk(clk),
    .ce(ce),
    .rst(rst),
    .di(di),
    .dv(dv),
    .po(po)
);

initial begin
    #4 ce = 1;
    #5 rst = 0;
    #10 di = 0;  //START
    #100 di = 1; //01010101
    #100 di = 0;
    #100 di = 1;
    #100 di = 0;
    #100 di = 1;
    #100 di = 0;
    #100 di = 1;
    #100 di = 0;
    #100 di = 1; //STOP

    #100 di = 0; //START
    #100 di = 1; //01010101
    #100 di = 0;
    #100 di = 1;
    #100 di = 0;
    #100 di = 1;
    #100 di = 0;
    #100 di = 1;
    #100 di = 0;
    #100 di = 0; //NO STOP

    #4000 $stop;
end

endmodule

