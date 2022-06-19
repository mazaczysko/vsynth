module bcd7seg_test (
	input CLK,
	output reg [7:0] SEG = 255,
	output reg [3:0] AN
);

wire [2:0] Q;
wire CEO;

up_cnt_mod #(
	.MODULO(4),
	.W(2)
)
cnt
(
	.CLK(CLK),
	.CE(CEO),
	.CLR(1'd0),
	.Q(Q)
);

prescaler #(
	.MODULO(500000),
	.W(27)
)
pre
(
	.CLK(CLK),
	.CE(1'd1),
	.CEO(CEO)
);

wire [3:0] AN_OUT;

assign AN_OUT[0] = ~(Q == 2'd0);
assign AN_OUT[1] = ~(Q == 2'd1);
assign AN_OUT[2] = ~(Q == 2'd2);
assign AN_OUT[3] = ~(Q == 2'd3);

always @(posedge CLK)
	if(CEO)
		AN <= AN_OUT;

always @(posedge CLK)
	if(CEO)
		case (Q)
			2'd0 : SEG <= 8'b00000011; 
			2'd1 : SEG <= 8'b10011111; 
			2'd2 : SEG <= 8'b00100101; 
			2'd3 : SEG <= 8'b00001101; 
		endcase


endmodule