module midi (
    input 			clk		 ,
    input 			rst		 ,

    input  [3:0]	channel	 ,
    input  [7:0]	data	 ,
    input 			dv		 ,
    
    output [6:0] 	note_num 	 ,
    output [6:0] 	note_vel 	 ,
    output [6:0] 	program 	 ,
    output     		note_on_out  ,
    output     		note_off_out
);

//FSM States
parameter RESET 	  = 3'b000;
parameter RECV 		  = 3'b001;
parameter DISPATCH 	  = 3'b010;
parameter RECV_NUM 	  = 3'b011;
parameter RECV_VEL    = 3'b100;
parameter HANDLE_NOTE = 3'b101;
parameter RECV_PROG   = 3'b110;
parameter HANDLE_PROG = 3'b111;

//MIDI status codes
parameter S_NOTE_OFF = 4'h8;
parameter S_NOTE_ON  = 4'h9;

wire [2:0] fsm_state;
wire [6:0] note_num_buf_out;
wire [6:0] note_vel_buf_out;
wire [6:0] program_buf_out;

wire [6:0] note_vel_or_off;
wire [7:0] current_status;

wire fsm_reset;
wire fsm_dispatch;
wire fsm_handle_prog;
wire fsm_handle_note;
wire fsm_handle_note_nand_note_off;
wire fsm_recv_num_and_dv;
wire fsm_recv_vel_and_dv;
wire fsm_recv_prog_and_dv;
wire reg_clr;

wire note_on;
wire note_off;

assign fsm_reset = fsm_state == RESET;
assign fsm_dispatch = fsm_state == DISPATCH;
assign fsm_handle_prog = fsm_state == HANDLE_PROG;
assign fsm_handle_note = fsm_state == HANDLE_NOTE;
assign fsm_handle_note_nand_note_off = fsm_state == HANDLE_NOTE & ~(current_status == {S_NOTE_OFF, channel});
assign fsm_recv_num_and_dv = fsm_state == RECV_NUM & dv;
assign fsm_recv_vel_and_dv = fsm_state == RECV_VEL & dv;
assign fsm_recv_prog_and_dv = fsm_state == RECV_PROG & dv;
assign reg_clr = rst | fsm_reset;

assign note_off = fsm_state == HANDLE_NOTE & (current_status == {S_NOTE_OFF, channel} || (current_status == {S_NOTE_ON, channel} && ~|note_vel_buf_out));
assign note_on  = fsm_state == HANDLE_NOTE & current_status == {S_NOTE_ON, channel};

//Sync output
register_clr #(
    .W(1)
)
note_off_register
(
    .clk ( clk			),
    .ce  ( 1'b1			),
    .clr ( reg_clr		),
    .d   ( note_off		),
    .q   ( note_off_out	)
);

register_clr #(
    .W(1)
)
note_on_register
(
    .clk ( clk			),
    .ce  ( 1'b1			),
    .clr ( reg_clr		),
    .d   ( note_on		),
    .q   ( note_on_out	)
);
    

//Input buffers

register_clr #(
    .W(8)
)
status_byte
(
    .clk ( clk				),
    .ce  ( fsm_dispatch		),
    .clr ( reg_clr			),
    .d   ( data				),
    .q   ( current_status	)
);

//Output registers

register_clr #(
    .W(7)
)
note_num_out
(
    .clk (clk				),
    .ce  (fsm_handle_note	),
    .clr (reg_clr			),
    .d   (note_num_buf_out	),
    .q   (note_num			)
);

register_clr #(
    .W(7)
)
note_vel_out
(
    .clk ( clk				),
    .ce  ( fsm_handle_note	),
    .clr ( reg_clr			),
    .d   ( note_vel_buf_out	),
    .q   ( note_vel			)
);

register_clr #(
    .W(7)
)
program_out
(
    .clk ( clk				),
    .ce  ( fsm_handle_prog	),
    .clr ( reg_clr			),
    .d   ( program_buf_out	),
    .q   ( program			)
);

//Buffers
register_clr #(
    .W(7)
)
note_num_buf
(
    .clk ( clk					),
    .ce  ( fsm_recv_num_and_dv	),
    .clr ( reg_clr				),
    .d   ( data[6:0]			),
    .q   ( note_num_buf_out		)
);

register_clr #(
    .W(7)
)
note_vel_buf
(
    .clk ( clk					),
    .ce  ( fsm_recv_vel_and_dv	),
    .clr ( reg_clr				),
    .d   ( data[6:0]			),
    .q   ( note_vel_buf_out		)
);

register_clr #(
    .W(7)
)
program_buf
(
    .clk ( clk					),
    .ce  ( fsm_recv_prog_and_dv	),
    .clr ( reg_clr				),
    .d   ( data[6:0]			),
    .q   ( program_buf_out		)
);

midi_fsm fsm(
    .clk     ( clk		 ),
    .rst     ( rst		 ),
    .channel ( channel	 ),
    .data    ( data		 ),
    .dv      ( dv		 ),
    .status  ( fsm_state )
);

endmodule

