module midi_fsm(
   input 			clk		,
	input			ce		,
	input 			rst		,
	input   [3:0]   channel	,	
	input   [7:0]	data	,
	input 			dv		,
	output  [2:0] 	status
);
    
//FSM States
parameter RESET 	  = 3'b000;
parameter RECV 		  = 3'b001;
parameter DISPATCH 	  = 3'b010;
parameter RECV_NUM 	  = 3'b011;
parameter RECV_VEL 	  = 3'b100;
parameter HANDLE_NOTE = 3'b101;
parameter RECV_PROG   = 3'b110;
parameter HANDLE_PROG = 3'b111;

//MIDI status codes
parameter S_NOTE_ON  = 4'h9;
parameter S_NOTE_OFF = 4'h8;
parameter S_PROGRAM  = 4'hc;
parameter S_RESET    = 8'hff;
    
reg [2:0] state = RESET;
assign status = state;

always @(posedge clk)
	if (rst)
		state <= RESET;
	else if (ce)
		case (state)
			RESET:
				state <= RECV;

			RECV:
				if (dv)
					if (data[7]) //Receive status byte
						state <= DISPATCH;
					else
						state <= RECV;
				else
					state <= RECV;

			DISPATCH:
				if (data == {S_NOTE_ON, channel} | data == {S_NOTE_OFF, channel})
					state <= RECV_NUM;
				else if (data == {S_PROGRAM, channel})
					state <= RECV_PROG;
				else if (data == S_RESET)
					state <= RESET;
				else
					state <= RECV;
			
			RECV_NUM:
				if (dv)
					if (data[7]) //Receive status byte
						state <= DISPATCH;
					else
						state <= RECV_VEL;
				else
					state <= RECV_NUM;

			RECV_VEL:
				if (dv)
					if (data[7]) //Receive status byte
						state <= DISPATCH;
					else 
						state <= HANDLE_NOTE;
				else
					state <= RECV_VEL;

			HANDLE_NOTE:
				state <= RECV;

			RECV_PROG:
				if (dv)
					if (data[7]) //Receive status byte
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