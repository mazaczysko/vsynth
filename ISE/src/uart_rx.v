
module uart_rx #(
    parameter CLKS_PER_BIT = 3200, //31250 baud -> MIDI
    parameter CLKS_PER_BIT_W = 12 //Counter_width
)
(
    input           CLK,
    input           CE,
    input           RST,
    input           DI,
    output          DV,
    output [7:0]    PO  
);

parameter HALF_BAUD = CLKS_PER_BIT/2;
parameter IDLE = 3'b000;
parameter START = 3'b001;
parameter START_CHECK = 3'b010;
parameter READ = 3'b011;
parameter STOP = 3'b100;

wire [2:0] status;
wire [CLKS_PER_BIT_W-1:0] baud_cnt;
wire [3:0] bit_cnt;
wire HB, BD, LB;
wire baud_reset;
reg data;

assign DV = (status == STOP) & BD & data;
assign HB = (baud_cnt == HALF_BAUD-1);
assign baud_reset = ((status == START) & HB) | (status == IDLE);

//Input buffer
always @(posedge CLK)
    data <= DI;

shift_reg #(
    .W(8)
)
out_reg
(
    .CLK(CLK),
    .CE( (status == READ) & BD ),
    .CLR(RST),
    .DIR(1'b1),
    .D(data),
    .Q(PO)
);


up_cnt_mod #(
    .MODULO(CLKS_PER_BIT),
    .W(CLKS_PER_BIT_W)
)
baud_counter
(
    .CLK(CLK),
    .CE(~baud_reset),
    .CLR(baud_reset),
    .Q(baud_cnt),
    .CO(BD)
);

up_cnt_mod #(
    .MODULO(8),
    .W(3)
)
bit_counter
(
    .CLK(CLK),
    .CE((status == READ) & BD),
    .CLR(status == IDLE),
    .Q(bit_cnt),
    .CO(LB)
);


uart_fsm fsm (
	.CLK(CLK),
	.CE(CE),
	.CLR(RST),
	.DI(data),
	.HB(HB),
	.BD(BD),
	.LB(LB),
	.STATUS(status)
);

endmodule