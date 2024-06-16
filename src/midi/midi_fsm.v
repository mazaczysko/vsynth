module midi_fsm(
    input 			clk		,
    input 			rst		,
    input   [3:0]   channel	,	
    input   [7:0]	data	,
    input 			dv		,
    output  [3:0] 	status
);
    
//FSM States
parameter RESET 	  = 4'd0;
parameter RECV 		  = 4'd1;
parameter DISPATCH 	  = 4'd2;
parameter RECV_NUM 	  = 4'd3;
parameter RECV_VEL 	  = 4'd4;
parameter HANDLE_NOTE = 4'd5;
parameter RECV_PROG   = 4'd6;
parameter HANDLE_PROG = 4'd7;
parameter RECV_CC_NUM = 4'd8;
parameter RECV_CC_VAL = 4'd9;
parameter HANDLE_CC   = 4'd10;

//MIDI status codes
parameter S_NOTE_ON  = 4'h9;
parameter S_NOTE_OFF = 4'h8;
parameter S_PROGRAM  = 4'hc;
parameter S_CC       = 4'hb;
parameter S_RESET    = 8'hff;
    
reg [3:0] state = RESET;
assign status = state;

always @(posedge clk)
    if (rst)
        state <= RESET;
    else
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
                else if (data == {S_CC, channel})
                    state <= RECV_CC_NUM;
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

            RECV_CC_NUM:
                if (dv)
                    if (data[7]) //Receive status byte
                        state <= DISPATCH;
                    else
                        state <= RECV_CC_VAL;
                else
                    state <= RECV_CC_NUM;

            RECV_CC_VAL:
                if (dv)
                    if (data[7]) //Receive status byte
                        state <= DISPATCH;
                    else 
                        state <= HANDLE_CC;
                else
                    state <= RECV_CC_VAL;

            HANDLE_CC:
                state <= RECV;

            default:
                state <= RESET;
        endcase

endmodule