module midi (
    input 			clk		 ,
    input 			rst		 ,

    input  [3:0]	channel	 ,
    input  [7:0]	data	 ,
    input 			dv		 ,
    
    output [6:0] 	note_num ,
    output [6:0] 	note_vel ,
    output [6:0] 	program  ,
    output [6:0]    cc_num   ,
    output [6:0]    cc_val   ,

    output     		note_on  ,
    output     		note_off ,
    output          cc_valid
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
parameter S_NOTE_OFF = 4'h8;
parameter S_NOTE_ON  = 4'h9;

wire [3:0] fsm_state;
wire [6:0] note_num_buf_out;
wire [6:0] note_vel_buf_out;
wire [6:0] program_buf_out;

wire [7:0] current_status;

wire fsm_reset;
wire fsm_dispatch;
wire fsm_handle_prog;
wire fsm_handle_note;
wire fsm_recv_num_and_dv;
wire fsm_recv_vel_and_dv;
wire fsm_recv_prog_and_dv;
wire fsm_recv_cc_num_and_dv;
wire fsm_recv_cc_val_and_dv;
wire reg_clr;

wire note_on_in;
wire note_off_in;

assign fsm_reset = fsm_state == RESET;
assign fsm_dispatch = fsm_state == DISPATCH;
assign fsm_handle_prog = fsm_state == HANDLE_PROG;
assign fsm_handle_note = fsm_state == HANDLE_NOTE;
assign fsm_recv_num_and_dv = fsm_state == RECV_NUM & dv;
assign fsm_recv_vel_and_dv = fsm_state == RECV_VEL & dv;
assign fsm_recv_prog_and_dv = fsm_state == RECV_PROG & dv;
assign fsm_recv_cc_num_and_dv = fsm_state == RECV_CC_NUM & dv;
assign fsm_recv_cc_val_and_dv = fsm_state == RECV_CC_VAL & dv;
assign reg_clr = rst | fsm_reset;

assign note_off_in = fsm_state == HANDLE_NOTE & (current_status == {S_NOTE_OFF, channel} || (current_status == {S_NOTE_ON, channel} && ~|note_vel_buf_out));
assign note_on_in  = fsm_state == HANDLE_NOTE & current_status == {S_NOTE_ON, channel};
assign cc_valid = fsm_state == HANDLE_CC;
//Sync output
register_clr #(
    .W(1)
)
note_off_register
(
    .clk ( clk			),
    .ce  ( 1'b1			),
    .clr ( reg_clr		),
    .d   ( note_off_in  ),
    .q   ( note_off     )
);

register_clr #(
    .W(1)
)
note_on_register
(
    .clk ( clk			),
    .ce  ( 1'b1			),
    .clr ( reg_clr		),
    .d   ( note_on_in   ),
    .q   ( note_on      )
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
    .clk ( clk				),
    .ce  ( fsm_handle_note	),
    .clr ( reg_clr			),
    .d   ( note_num_buf_out	),
    .q   ( note_num			)
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

register_clr #(
    .W(7)
)
cc_num_reg
(
    .clk ( clk					   ),
    .ce  ( fsm_recv_cc_num_and_dv  ),
    .clr ( reg_clr				   ),
    .d   ( data[6:0]               ),
    .q   ( cc_num                  )
);

register_clr #(
    .W(7)
)
cc_val_reg
(
    .clk ( clk					  ),
    .ce  ( fsm_recv_cc_val_and_dv ),
    .clr ( reg_clr				  ),
    .d   ( data[6:0]			  ),
    .q   ( cc_val                 )
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

