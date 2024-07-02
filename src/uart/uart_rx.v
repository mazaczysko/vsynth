module uart_rx #(
    parameter CLKS_PER_BIT = 3200, //31250 baud -> MIdi
    parameter CLKS_PER_BIT_W = 12 //Counter_width
)
(
    input           clk,
    input           ce,
    input           rst,
    input           di,
    output          dv,
    output [7:0]    po  
);

localparam HALF_BAUD = CLKS_PER_BIT/2;
localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam START_CHECK = 3'b010;
localparam READ = 3'b011;
localparam STOP = 3'b100;

wire [2:0] status;
wire [CLKS_PER_BIT_W-1:0] baud_cnt;
wire [2:0] bit_cnt;
wire hb, bd, lb;
wire baud_reset;
reg  data;

assign dv = (status == STOP) & bd & data;
assign hb = (baud_cnt == HALF_BAUD-1);
assign baud_reset = ((status == START) & hb) | (status == IDLE);

//Input buffer
always @(posedge clk)
    data <= di;

shift_reg #(
    .W(8)
)
out_reg
(
    .clk ( clk                   ),
    .ce  ( (status == READ) & bd ),
    .clr ( rst                   ),
    .dir ( 1'b1                  ),
    .d   ( data                  ),
    .q   ( po                    )
);


up_cnt_mod #(
    .MODULO(CLKS_PER_BIT),
    .W(CLKS_PER_BIT_W)
)
baud_counter
(
    .clk ( clk          ),
    .ce  ( ~baud_reset  ),
    .clr ( baud_reset   ),
    .q   ( baud_cnt     ),
    .co  ( bd           )
);

up_cnt_mod #(
    .MODULO(8),
    .W(3)
)
bit_counter
( 
    .clk ( clk                   ),
    .ce  ( (status == READ) & bd ),
    .clr ( status == IDLE        ),
    .q   ( bit_cnt               ),
    .co  ( lb                    )
);


uart_fsm fsm (
    .clk    ( clk    ),
    .ce     ( ce     ),
    .clr    ( rst    ),
    .di     ( data   ),
    .hb     ( hb     ),
    .bd     ( bd     ),
    .lb     ( lb     ),
    .status ( status )
);

endmodule