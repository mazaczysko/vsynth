module vsynth_top (
    input 	     clk		 ,
    input 		 di			 ,
    input  [3:0] channel	 ,
    output [3:0] channel_led ,
    
    input        wtb_load    ,
    input  [4:0] wtb_num     ,
    output [4:0] wtb_num_led ,    

    output [7:0] sample_out  ,
    
    output [7:0] seg         ,
    output [7:0] an
);

wire uart_dv;
wire [7:0] uart_out;

wire note_on;
wire note_off;

wire [6:0] note_num;
wire [6:0] note_vel;
wire [6:0] program;

wire [3:0] wtb_ram_we;
wire [5:0] wtb_ram_addr_w;  
wire [7:0] wtb_ram_wfm_l_w; 
wire [7:0] wtb_ram_wfm_r_w; 
wire [7:0] wtb_ram_factor_w;

wire [5:0] wtb_ram_addr_r;  
wire [7:0] wtb_ram_wfm_l_r; 
wire [7:0] wtb_ram_wfm_r_r; 
wire [7:0] wtb_ram_factor_r;

reg  [4:0] curr_wtb_num;
wire       wtb_load_done;
wire [4:0] wtb_load_num;

wire wtb_load_pedge;

wire sample_rate_ceo;

wire [6:0] nco_phase;


assign channel_led = channel;
assign wtb_num_led = wtb_num;

assign an[7:4] = 4'b1111;

debouncer_pulse #(
    .W                  ( 8       ),
    .PRESCALER_MODULO   ( 1000000 ),
    .PRESCALER_MODULO_W ( 20      )
)
wtb_load_debouncer_inst
(
  .clk       ( clk            ),
  .rst       ( 1'b0           ),
  .sig       ( wtb_load       ),
  .sig_pedge ( wtb_load_pedge ),
  .sig_nedge (                )
);

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
    .rst        ( rst   ),

    .channel    ( channel   ),
    .data	    ( uart_out  ),
    .dv		    ( uart_dv   ),
    
    .note_num 	( note_num  ),
    .note_vel 	( note_vel  ),
    .program 	( program   ),
    .note_on_out    ( note_on  ),
    .note_off_out   ( note_off )
);

wtb_synthesis wtb_synthesis_inst (
    .clk            ( clk             ),
    .wtb_load       ( wtb_load_pedge  ),
    .wtb_num        ( wtb_num         ),   
    .wtb_load_num   ( wtb_load_num    ),
    .wtb_load_done  ( wtb_load_done   ),
    .program        ( program         ),
    .note_num       ( note_num        ),
    .sample_out     ( sample_out      ),
    .sample_rate_out(                 )
);



always @(posedge  clk)
    if(wtb_load_done)
        curr_wtb_num <= wtb_load_num;

seg_8bit disp (
    .clk    ( clk          ),
    .ce     ( 1'd1         ),
    .bin_in ( curr_wtb_num ),
    .seg    ( seg          ),
    .an     ( an[3:0]      )
);

endmodule