`timescale 1ns / 1ps

module uart_rx_tb;

reg CLK, CE, RST, DI;
wire DV;
wire [7:0] PO;

initial begin
    CLK = 0;
    RST = 1;
    CE = 0;
    DI = 1;
end

always #1 CLK = ~CLK;

uart_rx #(
    .CLKS_PER_BIT(50),
    .CLKS_PER_BIT_W(6)
)
uart_receiver
(
    .CLK(CLK),
    .CE(CE),
    .RST(RST),
    .DI(DI),
    .DV(DV),
    .PO(PO)
);

initial begin
    #4 CE = 1;
    #5 RST = 0;
    #10 DI = 0;  //START
    #100 DI = 1; //01010101
    #100 DI = 0;
    #100 DI = 1;
    #100 DI = 0;
    #100 DI = 1;
    #100 DI = 0;
    #100 DI = 1;
    #100 DI = 0;
    #100 DI = 1; //STOP

    #100 DI = 0; //START
    #100 DI = 1; //01010101
    #100 DI = 0;
    #100 DI = 1;
    #100 DI = 0;
    #100 DI = 1;
    #100 DI = 0;
    #100 DI = 1;
    #100 DI = 0;
    #100 DI = 0; //NO STOP

    #4000 $stop;
end

endmodule

