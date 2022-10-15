module midi (
	input 			CLK,
	input 			CE,
	input 			RST,
	input  [3:0]	CHANNEL,
	input  [7:0]	DATA,
	input 			DV,
	output [6:0] 	NOTE_NUM,
	output [6:0] 	NOTE_VEL,
	output [6:0] 	PROGRAM,
	output			HANDLE_NOTE,
	output 			NOTE_ON,
	output 			NOTE_OFF
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
parameter S_NOTE_OFF = 4'h8;
parameter S_NOTE_ON = 4'h9;

wire [2:0] fsm_state;
wire [6:0] note_num_buf_out;
wire [6:0] note_vel_buf_out;
wire [6:0] program_buf_out;

wire [6:0] note_vel_or_off;
wire [7:0] current_status;

wire fsm_reset;
wire fsm_dispatch;
wire fsm_handle_prog;
wire fsm_handle_note_nand_note_off;
wire fsm_recv_num_and_dv;
wire fsm_recv_vel_and_dv;
wire fsm_recv_prog_and_dv;
wire reg_clr;

assign fsm_reset = fsm_state == RESET;
assign fsm_dispatch = fsm_state == DISPATCH;
assign fsm_handle_prog = fsm_state == HANDLE_PROG;
assign fsm_handle_note = fsm_state == HANDLE_NOTE;
assign fsm_handle_note_nand_note_off = fsm_state == HANDLE_NOTE & ~(current_status == {S_NOTE_OFF, CHANNEL});
assign fsm_recv_num_and_dv = fsm_state == RECV_NUM & DV;
assign fsm_recv_vel_and_dv = fsm_state == RECV_VEL & DV;
assign fsm_recv_prog_and_dv = fsm_state == RECV_PROG & DV;
assign reg_clr = RST | fsm_reset;

assign NOTE_OFF = fsm_state == HANDLE_NOTE & current_status == {S_NOTE_OFF, CHANNEL};
assign NOTE_ON = fsm_state == HANDLE_NOTE & current_status == {S_NOTE_ON, CHANNEL};


//Input buffers

register_clr #(
	.W(8)
)
status_byte
(
	.CLK(CLK),
	.CE(fsm_dispatch),
	.CLR(reg_clr),
	.D(DATA),
	.Q(current_status)
);

//Output registers
register #(
	.W(1)
)
HANDLE_NOTE_out
(
	.CLK(CLK),
	.CE(1'b1),
	.D(fsm_handle_note),
	.Q(HANDLE_NOTE)
);


register_clr #(
	.W(7)
)
NOTE_NUM_out
(
	.CLK(CLK),
	.CE(fsm_handle_note),
	.CLR(reg_clr),
	.D(note_num_buf_out),
	.Q(NOTE_NUM)
);

register_clr #(
	.W(7)
)
NOTE_VEL_out
(
	.CLK(CLK),
	.CE(fsm_handle_note),
	.CLR(reg_clr),
	.D(note_vel_buf_out),
	.Q(NOTE_VEL)
);

register_clr #(
	.W(7)
)
PROGRAM_out
(
	.CLK(CLK),
	.CE(fsm_handle_prog),
	.CLR(reg_clr),
	.D(program_buf_out),
	.Q(PROGRAM)
);

//Buffers
register_clr #(
	.W(7)
)
NOTE_NUM_buf
(
	.CLK(CLK),
	.CE(fsm_recv_num_and_dv),
	.CLR(reg_clr),
	.D(DATA[6:0]),
	.Q(note_num_buf_out)
);

register_clr #(
	.W(7)
)
NOTE_VEL_buf
(
	.CLK(CLK),
	.CE(fsm_recv_vel_and_dv),
	.CLR(reg_clr),
	.D(DATA[6:0]),
	.Q(note_vel_buf_out)
);

register_clr #(
	.W(7)
)
PROGRAM_buf
(
	.CLK(CLK),
	.CE(fsm_recv_prog_and_dv),
	.CLR(reg_clr),
	.D(DATA[6:0]),
	.Q(program_buf_out)
);


midi_fsm fsm(
	.CLK(CLK),
	.CE(CE),
	.RST(RST),
	.CHANNEL(CHANNEL),
	.DATA(DATA),
	.DV(DV),
	.STATUS(fsm_state)
);

endmodule

module polyphony (
	input CLK,
	input CE,
	input RST,
	input [6:0] NOTE_NUM,
	input [6:0] NOTE_VEL,
	input HANDLE_NOTE,
	input NOTE_ON,
	input NOTE_OFF,
	output [6:0] NOTE_NUM_0,
	output [6:0] NOTE_NUM_1,
	output [6:0] NOTE_NUM_2,
	output [6:0] NOTE_NUM_3,
	output [6:0] NOTE_VEL_0,
	output [6:0] NOTE_VEL_1,
	output [6:0] NOTE_VEL_2,
	output [6:0] NOTE_VEL_3,
);

wire write_note_0;
wire write_note_1;
wire write_note_2;
wire write_note_3;

wire clr_note_0;
wire clr_note_1;
wire clr_note_2;
wire clr_note_3;


//Output registers

//NOTE_NUM registers
register_clr #(
	.W(7)
)
NOTE_NUM_0
(
	.CLK(CLK),
	.CE(write_note_0)
	.CLR(RST),
	.D(NOTE_NUM),
	.Q(NOTE_NUM_0)
);

register_clr #(
	.W(7)
)
NOTE_NUM_1
(
	.CLK(CLK),
	.CE(write_note_1)
	.CLR(RST),
	.D(NOTE_NUM),
	.Q(NOTE_NUM_1)
);

register_clr #(
	.W(7)
)
NOTE_NUM_2
(
	.CLK(CLK),
	.CE(write_note_2)
	.CLR(RST),
	.D(NOTE_NUM),
	.Q(NOTE_NUM_2)
);

register_clr #(
	.W(7)
)
NOTE_NUM_3
(
	.CLK(CLK),
	.CE(write_note_3)
	.CLR(RST),
	.D(NOTE_NUM),
	.Q(NOTE_NUM_3)
);

//NOTE_VEL registers
register_clr #(
	.W(7)
)
NOTE_VEL_0
(
	.CLK(CLK),
	.CE(write_note_0)
	.CLR(RST | clr_note_0),
	.D(NOTE_VEL),
	.Q(NOTE_VEL_0)
);

register_clr #(
	.W(7)
)
NOTE_VEL_1
(
	.CLK(CLK),
	.CE(write_note_1)
	.CLR(RST | clr_note_1),
	.D(NOTE_VEL),
	.Q(NOTE_VEL_1)
);

register_clr #(
	.W(7)
)
NOTE_VEL_2
(
	.CLK(CLK),
	.CE(write_note_2)
	.CLR(RST | clr_note_2),
	.D(NOTE_VEL),
	.Q(NOTE_VEL_2)
);

register_clr #(
	.W(7)
)
NOTE_VEL_3
(
	.CLK(CLK),
	.CE(write_note_3)
	.CLR(RST | clr_note_3),
	.D(NOTE_VEL),
	.Q(NOTE_VEL_3)
);


always @(posedge CLK) 
	if(CE)
		if (HANDLE_NOTE && NOTE_ON)
			if (~|NOTE_VEL_0) ///NOTE_VEL_0 == 7'd0;
				write_note_0 = 1'b1;

			else if(~|NOTE_VEL_1)
				write_note_1 = 1'b1;

			else if(~|NOTE_VEL_2)
				write_note_2 = 1'b1;

			else if(~|NOTE_VEL_3)
				write_note_3 = 1'b1;
			
			else begin
				write_note_0 = 1'b0;
				write_note_1 = 1'b0;
				write_note_2 = 1'b0;
				write_note_3 = 1'b0;
			end
		else begin
			write_note_0 = 1'b0;
			write_note_1 = 1'b0;
			write_note_2 = 1'b0;
			write_note_3 = 1'b0;
		end		


always @(posedge CLK)
	if(CE)
		if(HANDLE_NOTE && NOTE_OFF)
			if (NOTE_NUM == NOTE_NUM_0)
				clr_note_0 = 1'b1;

			else if (NOTE_NUM == NOTE_NUM_1)
				clr_note_1 = 1'b1;

			else if (NOTE_NUM == NOTE_NUM_2)
				clr_note_2 = 1'b1;

			else if (NOTE_NUM == NOTE_NUM_3)
				clr_note_3 = 1'b1;	

			else begin
				clr_note_0 = 1'b0;
				clr_note_1 = 1'b0;
				clr_note_2 = 1'b0;
				clr_note_3 = 1'b0;
			end
		else begin
				clr_note_0 = 1'b0;
				clr_note_1 = 1'b0;
				clr_note_2 = 1'b0;
				clr_note_3 = 1'b0;
		end

endmodule