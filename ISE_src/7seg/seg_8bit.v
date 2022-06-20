module seg_8bit (
	input CLK,
	input CE,
	input [7:0] BIN_IN,
	output reg [7:0] SEG = 255,
	output reg [3:0] AN
);

wire [2:0] Q;
wire CEO;


wire [11:0] bcd;

bin2bcd conv (
	.BIN(BIN_IN),
	.BCD(bcd)
);

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


wire [7:0] seg0;
wire [7:0] seg1;
wire [7:0] seg2;
wire [7:0] seg3;

bcd7seg bcdseg0 (
	.CLK(CLK),
	.CE(1'd1),
	.BCD(bcd[3:0]),
	.SEG(seg0)
);

bcd7seg bcdseg1 (
	.CLK(CLK),
	.CE(1'd1),
	.BCD(bcd[7:4]),
	.SEG(seg1)
);

bcd7seg bcdseg2 (
	.CLK(CLK),
	.CE(1'd1),
	.BCD(bcd[11:8]),
	.SEG(seg2)
);

bcd7seg bcdseg3 (
	.CLK(CLK),
	.CE(1'd1),
	.BCD(4'd0),
	.SEG(seg3)
);




always @(posedge CLK)
	if(CEO)
		AN <= AN_OUT;

always @(posedge CLK)
	if(CEO)
		case (Q)
			2'd0 : SEG <= seg0; 
			2'd1 : SEG <= seg1; 
			2'd2 : SEG <= seg2; 
			2'd3 : SEG <= {seg3[7:1],1'd0}; 
		endcase


endmodule