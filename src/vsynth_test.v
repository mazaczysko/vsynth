module vsynth_test (
	input 	     clk		 ,
	input 		 di			 ,
	input  [3:0] channel	 ,
	output [3:0] channel_led ,
	output [7:0] sample_out  ,
	output [7:0] seg         ,
	output [7:0] an
);

wire dv;
wire [7:0] uart_out;

wire [6:0] note_num;
wire [6:0] note_vel;
wire [6:0] program;

wire [6:0] note_num_0;
wire [6:0] note_num_1;
wire [6:0] note_num_2;
wire [6:0] note_num_3;

wire [6:0] note_vel_0;
wire [6:0] note_vel_1;
wire [6:0] note_vel_2;
wire [6:0] note_vel_3;

assign channel_led = channel;
assign an[7:4] = 4'b1111;

uart_rx uart (
    .clk ( clk		),
    .ce  ( 1'd1		),
    .rst ( 1'd0		),
    .di  ( di		),
    .dv  ( dv		),
    .po  ( uart_out	)
);

poly_midi midi_interpreter(
    .clk	    ( clk        ),
    .ce         ( 1'd1       ),
    .rst        ( 1'd0       ),
    .channel    ( channel    ),
    .data       ( uart_out   ),
    .dv         ( dv         ),
    .program    ( program    ),
    .note_num_0 ( note_num_0 ),
    .note_num_1 ( note_num_1 ),
    .note_num_2 ( note_num_2 ),
    .note_num_3 ( note_num_3 ),
    .note_vel_0 ( note_vel_0 ),
    .note_vel_1 ( note_vel_1 ),
    .note_vel_2 ( note_vel_2 ),
    .note_vel_3 ( note_vel_3 )
);

nco_bank voice (
    .clk            ( clk        ),
    .ce             ( 1'd1       ),
    .rst            ( 1'b0       ),
    .program        ( program    ),
    .note_num_0     ( note_num_0 ),
    .note_num_1     ( note_num_1 ),
    .note_num_2     ( note_num_2 ),
    .note_num_3     ( note_num_3 ),
    .note_vel_0     ( note_vel_0 ),
    .note_vel_1     ( note_vel_1 ),
    .note_vel_2     ( note_vel_2 ),
    .note_vel_3     ( note_vel_3 ),	
	.sample_sum_out ( sample_out )
);

seg_8bit disp (
    .clk    ( clk       ),
    .ce     ( 1'd1      ),
    .bin_in ( program   ),
    .seg    ( seg       ),
    .an     ( an[3:0]   )
);

endmodule