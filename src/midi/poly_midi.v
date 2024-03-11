module poly_midi(
	input 			clk ,
	input 			ce  ,
	input 			rst ,

	input  [3:0]	channel ,
	input  [7:0]	data    ,
	input 			dv      ,
	
    output [6:0]    program     ,
	output [6:0]    note_num_0  ,
	output [6:0]    note_num_1  ,
	output [6:0]    note_num_2  ,
	output [6:0]    note_num_3  ,
	output [6:0]    note_vel_0  ,
	output [6:0]    note_vel_1  ,
	output [6:0]    note_vel_2  ,
	output [6:0]    note_vel_3
);


wire note_off_out ;
wire note_on_out  ;

wire [6:0] note_num_out ;
wire [6:0] note_vel_out ;

midi interprter(
    .clk          ( clk             ),
    .ce           ( ce              ),
    .rst          ( rst             ),
    .channel      ( channel         ),
    .data         ( data            ),
    .dv           ( dv              ),
    .note_num     ( note_num_out    ),
    .note_vel     ( note_vel_out    ),
    .program      ( program         ),
    .note_on_out  ( note_on_out     ),
    .note_off_out ( note_off_out    )
);

polyphony poly(
    .clk        ( clk           ),
    .ce         ( ce            ),
    .rst        ( rst           ),
    .note_num   ( note_num_out  ),
    .note_vel   ( note_vel_out  ),
    .note_on    ( note_on_out   ),
    .note_off   ( note_off_out  ),
    .note_num_0 ( note_num_0    ),
    .note_num_1 ( note_num_1    ),
    .note_num_2 ( note_num_2    ),
    .note_num_3 ( note_num_3    ),
    .note_vel_0 ( note_vel_0    ),
    .note_vel_1 ( note_vel_1    ),
    .note_vel_2 ( note_vel_2    ),
    .note_vel_3 ( note_vel_3    )
);

endmodule
