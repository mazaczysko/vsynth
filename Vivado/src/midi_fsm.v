module midi_fsm(
    input 			CLK,
	input			CE,
	input 			RST, 
	input [7:0]		DATA,
	input 			DV,
	output  [2:0]  	STATUS
);
    
//FSM States
parameter RESET = 3'b000;
parameter RECV = 3'b001;
parameter DISPATCH = 3'b010;
parameter RECV_NUM = 3'b011;
parameter RECV_VEL = 3'b100;
parameter HANDLE_NOTE = 3'b101;
parameter RECV_PROG = 3'b110;
parameter HANDLE_PROG = 3'b111;
    
reg [2:0] state = RESET;
assign STATUS = state;

always @(posedge CLK)
	if (RST)
		state <= RESET;
	else if (CE)
		case (state)
			RESET:
				state <= RECV;

			RECV:
				if (DV)
					if (DATA[7]) //Receive status byte
						state <= DISPATCH;
					else
						state <= RECV;
				else
					state <= RECV;

			DISPATCH:
				if (DATA == 8'h90 | DATA == 8'h80)
					state <= RECV_NUM;
				else if (DATA == 8'hc0)
					state <= RECV_PROG;
				else if (DATA == 8'hff)
					state <= RESET;
				else
					state <= RECV;
			
			RECV_NUM:
				if (DV)
					if (DATA[7]) //Receive status byte
						state <= DISPATCH;
					else
						state <= RECV_VEL;
				else
					state <= RECV_NUM;

			RECV_VEL:
				if (DV)
					if (DATA[7]) //Receive status byte
						state <= DISPATCH;
					else 
						state <= HANDLE_NOTE;
				else
					state <= RECV_VEL;

			HANDLE_NOTE:
				state <= RECV;

			RECV_PROG:
				if (DV)
					if (DATA[7]) //Receive status byte
						state <= DISPATCH;
					else 
						state <= HANDLE_PROG;
				else
					state <= RECV_PROG;

			HANDLE_PROG:
				state <= RECV;

			default:
				state <= RESET;
		endcase

endmodule