module vsynth_top (
    input 	     clk		 ,
    input 		 di			 ,
    input  [3:0] channel	 ,
    output [3:0] channel_led ,

    output [7:0] sample_out  ,
    
    output [7:0] seg         ,
    output [7:0] an
);

wire uart_dv;
wire [7:0] uart_out;

wire [6:0] note_num;
wire [6:0] note_vel;
wire [6:0] program;
wire [6:0] wfm_num;
wire [6:0] cc_num;
wire [6:0] cc_val;

wire note_on;
wire note_off;
wire cc_valid;

reg  [4:0] curr_wtb_num;
wire       wtb_load_done;
wire [4:0] wtb_load_num;

wire wtb_load;
wire [4:0] wtb_num;

wire sample_rate_ceo;

wire [6:0] note_num0;
wire [6:0] note_num1;
wire [6:0] note_num2;
wire [6:0] note_num3;
wire [6:0] note_vel0;
wire [6:0] note_vel1;
wire [6:0] note_vel2;
wire [6:0] note_vel3;

wire [7:0] sample_out0;
wire [7:0] sample_out1;
wire [7:0] sample_out2;
wire [7:0] sample_out3;

wire [11:0] sample_sum;
wire [7:0]  sample_sum_divided_8bit;
reg  [7:0]  sample_out_reg;

assign channel_led = channel;
assign an[7:4] = 4'b1111; 

assign sample_sum = sample_out0 + sample_out1 + sample_out2 + sample_out3;
assign sample_sum_divided_8bit = sample_sum[9:2]; 
assign sample_out = sample_out_reg; 


uart_rx uart (
    .clk ( clk		),
    .ce  ( 1'd1		),
    .rst ( 1'd0		),
    .di  ( di		),
    .dv  ( uart_dv  ),
    .po  ( uart_out	)
);

midi midi_inst (
    .clk        ( clk   ),
    .rst        ( 1'd0  ),

    .channel    ( channel   ),
    .data	    ( uart_out  ),
    .dv		    ( uart_dv   ),
    
    .note_num 	( note_num  ),
    .note_vel 	( note_vel  ),
    .program 	( program   ),
    .cc_num     ( cc_num    ),
    .cc_val     ( cc_val    ),

    .note_on    ( note_on   ),
    .note_off   ( note_off  ),
    .cc_valid   ( cc_valid  )
);

polyphony polyphony_inst (
    .clk        ( clk       ),
    .ce         ( 1'b1      ),
    .rst        ( rst       ),
    .note_num   ( note_num  ),
    .note_vel   ( note_vel  ),
    .note_on    ( note_on   ),
    .note_off   ( note_off  ),
    .note_num_0 ( note_num0 ),
    .note_num_1 ( note_num1 ),
    .note_num_2 ( note_num2 ),
    .note_num_3 ( note_num3 ),
    .note_vel_0 ( note_vel0 ),
    .note_vel_1 ( note_vel1 ),
    .note_vel_2 ( note_vel2 ),
    .note_vel_3 ( note_vel3 )
);

cc_decoder cc_decoder_inst (
    .clk ( clk ),
    .rst ( rst ),

    .cc_num   ( cc_num   ),
    .cc_val   ( cc_val   ),
    .cc_valid ( cc_valid ),

    .wtb_load ( wtb_load ),
    .wtb_num  ( {2'd0,wtb_num}),
    .wfm_num  ( {2'd0,wfm_num})
);

prescaler #(
    .MODULO ( 3125 ),
    .W      ( 12   )
)
sample_rate_prescaler
(
    .clk ( clk             ),
    .ce  ( 1'b1            ),
    .ceo ( sample_rate_ceo )
);

wtb_synthesis wtb_synthesis_inst0 (
    .clk            ( clk             ),
    .sample_rate    ( sample_rate_ceo ),
    .wtb_load       ( wtb_load        ),
    .wtb_num        ( wtb_num[4:0]    ),   
    .wtb_load_num   ( wtb_load_num    ),
    .wtb_load_done  ( wtb_load_done   ),
    .program        ( wfm_num         ),
    .note_num       ( note_num0       ),
    .note_vel       ( note_vel0       ),
    .sample_out     ( sample_out0     )
);

wtb_synthesis wtb_synthesis_inst1 (
    .clk            ( clk             ),
    .sample_rate    ( sample_rate_ceo ),
    .wtb_load       ( wtb_load        ),
    .wtb_num        ( wtb_num         ),   
    .wtb_load_num   (                 ),
    .wtb_load_done  (                 ),
    .program        ( wfm_num         ),
    .note_num       ( note_num1       ),
    .note_vel       ( note_vel1       ),
    .sample_out     ( sample_out1     )
);

wtb_synthesis wtb_synthesis_inst2 (
    .clk            ( clk             ),
    .sample_rate    ( sample_rate_ceo ),
    .wtb_load       ( wtb_load        ),
    .wtb_num        ( wtb_num         ),   
    .wtb_load_num   (                 ),
    .wtb_load_done  (                 ),
    .program        ( wfm_num         ),
    .note_num       ( note_num2       ),
    .note_vel       ( note_vel2       ),
    .sample_out     ( sample_out2     )
);

wtb_synthesis wtb_synthesis_inst3 (
    .clk            ( clk             ),
    .sample_rate    ( sample_rate_ceo ),
    .wtb_load       ( wtb_load        ),
    .wtb_num        ( wtb_num         ),   
    .wtb_load_num   (                 ),
    .wtb_load_done  (                 ),
    .program        ( wfm_num         ),
    .note_num       ( note_num3       ),
    .note_vel       ( note_vel3       ),
    .sample_out     ( sample_out3     )
);

always @(posedge clk)
        sample_out_reg <= sample_sum_divided_8bit;

always @(posedge  clk)
    if(wtb_load_done)
        curr_wtb_num <= wtb_load_num;

seg_8bit disp (
    .clk     ( clk          ),
    .ce      ( 1'd1         ),
    .bin_in0 ( curr_wtb_num ),
    .bin_in1 ( wfm_num      ),
    .seg     ( seg          ),
    .an      ( an[3:0]      )
);

endmodule