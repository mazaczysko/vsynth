module midi (
	input 			CLK,
	input 			CE,
	input 			RST,
	input  [7:0]	DATA,
	input 			DV,
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
assign fsm_handle_note_nand_note_off = fsm_state == HANDLE_NOTE & ~(current_status == 8'h80);
assign fsm_recv_num_and_dv = fsm_state == RECV_NUM & DV;
assign fsm_recv_vel_and_dv = fsm_state == RECV_VEL & DV;
assign fsm_recv_prog_and_dv = fsm_state == RECV_PROG & DV;
assign reg_clr = RST | fsm_reset;

wire note_off;
assign note_off = (fsm_state == HANDLE_NOTE & current_status == 8'h80 & NOTE_NUM == note_num_buf_out);


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
register_clr #(
	.W(7)
)
NOTE_NUM_out
(
	.CLK(CLK),
	.CE(fsm_handle_note_nand_note_off),
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
	.CE(fsm_handle_note_nand_note_off),
	.CLR(reg_clr | note_off),
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

//Output buffers
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
	.DATA(DATA),
	.DV(DV),
	.STATUS(fsm_state)
);

endmodule

