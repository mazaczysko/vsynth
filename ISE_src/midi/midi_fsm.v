module midi_fsm(
   input 			CLK,
	input				CE,
	input 			RST,
	input   [3:0]  CHANNEL,
	input   [7:0]	DATA,
	input 			DV,
	output  [2:0] 	STATUS
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

//MIDI status codes
parameter S_NOTE_ON = 4'h9;
parameter S_NOTE_OFF = 4'h8;
parameter S_PROGRAM = 4'hc;
parameter S_RESET = 8'hff;
    
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
				if (DATA == {S_NOTE_ON, CHANNEL} | DATA == {S_NOTE_OFF, CHANNEL})
					state <= RECV_NUM;
				else if (DATA == {S_PROGRAM, CHANNEL})
					state <= RECV_PROG;
				else if (DATA == S_RESET)
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