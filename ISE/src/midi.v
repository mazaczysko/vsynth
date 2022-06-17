module midi (
	input 			CLK,
	input 			CE,
	input 			RST,
	input  [7:0]	data,
	input 			dv,
	output [6:0] 	NOTE_NUM,
	output [6:0] 	NOTE_VEL,
	output [6:0] 	PROGRAM
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

wire [2:0] fsm_state;
wire [6:0] note_num_buf_out;
wire [6:0] note_vel_buf_out;
wire [6:0] program_buf_out;

wire [6:0] note_vel_or_off;
wire [7:0] current_status;

wire fsm_reset;

assign fsm_reset = fsm_state == RESET;

//if current_status == NOTE_OFF and received and current played notes are the same -> set vel to 0
//assign note_vel_or_off = current_status == 8'h80 & NOTE_NUM == note_num_buf_out ? 7'd0 : note_vel_buf_out;

wire note_off;

assign note_off = (fsm_state == HANDLE_NOTE & current_status == 8'h80 & NOTE_NUM == note_num_buf_out);

//Input buffers


register_clr #(
	.W(8)
)
status_byte
(
	.CLK(CLK),
	.CE(fsm_state == DISPATCH),
	.CLR(RST | fsm_reset),
	.D(data),
	.Q(current_status)
);

//Output registers
register_clr #(
	.W(7)
)
NOTE_NUM_out
(
	.CLK(CLK),
	.CE(fsm_state == HANDLE_NOTE & ~(current_status == 8'h80)),
	.CLR(RST | fsm_reset),
	.D(note_num_buf_out),
	.Q(NOTE_NUM)
);

register_clr #(
	.W(7)
)
NOTE_VEL_out
(
	.CLK(CLK),
	.CE(fsm_state == HANDLE_NOTE & ~(current_status == 8'h80)),
	.CLR(RST | fsm_reset | note_off),
	.D(note_vel_buf_out),
	.Q(NOTE_VEL)
);

register_clr #(
	.W(7)
)
PROGRAM_out
(
	.CLK(CLK),
	.CE(fsm_state == HANDLE_PROG),
	.CLR(RST | fsm_reset),
	.D(program_buf_out),
	.Q(PROGRAM)
);

//Output buffers
register_clr #(
	.W(7)
)
NOTE_NUM_buf
(
	.CLK(CLK),
	.CE(fsm_state == RECV_NUM & dv),
	.CLR(RST | fsm_reset),
	.D(data[6:0]),
	.Q(note_num_buf_out)
);

register_clr #(
	.W(7)
)
NOTE_VEL_buf
(
	.CLK(CLK),
	.CE(fsm_state == RECV_VEL & dv),
	.CLR(RST | fsm_reset),
	.D(data[6:0]),
	.Q(note_vel_buf_out)
);

register_clr #(
	.W(7)
)
PROGRAM_buf
(
	.CLK(CLK),
	.CE(fsm_state == RECV_PROG & dv),
	.CLR(RST | fsm_reset),
	.D(data[6:0]),
	.Q(program_buf_out)
);


midi_fsm fsm(
	.CLK(CLK),
	.CE(CE),
	.RST(RST),
	.DATA(data),
	.DV(dv),
	.STATUS(fsm_state)
);



endmodule