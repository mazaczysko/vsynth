module vsynth_top (
    input 	     clk		 ,
    input 		 di			 ,
    input  [3:0] channel	 ,
    output [3:0] channel_led ,

    output [7:0] sample_out  ,
    
    output [7:0] seg         ,
    output [7:0] an
);

localparam VOICE_NUM = 4;

wire uart_dv;
wire [7:0] uart_out;

wire [6:0] note_num_m;
wire [6:0] note_vel_m;
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

wire [6:0] adsr_a;
wire [6:0] adsr_d;
wire [6:0] adsr_s;
wire [6:0] adsr_r;

wire sample_rate_ceo;
wire rst;

wire [6:0] note_num [3:0];
wire [6:0] note_vel [3:0];


wire gate_on  [3:0]; 
wire gate_off [3:0];
wire [6:0] env_out [3:0];

wire [7:0] out_sample [3:0];

wire [11:0] sample_sum;
wire [7:0]  sample_sum_divided_8bit;
reg  [7:0]  sample_out_reg;

assign channel_led = channel;
assign an[7:4] = 4'b1111; 

assign sample_sum = out_sample[0] + out_sample[1] + out_sample[2] + out_sample[3];
assign sample_sum_divided_8bit = sample_sum[9:2]; 
assign sample_out = sample_out_reg; 

assign rst = 1'b0;

uart_rx uart (
    .clk ( clk		),
    .ce  ( 1'd1		),
    .rst ( rst 		),
    .di  ( di		),
    .dv  ( uart_dv  ),
    .po  ( uart_out	)
);

midi midi_inst (
    .clk        ( clk   ),
    .rst        ( rst   ),

    .channel    ( channel    ),
    .data	    ( uart_out   ),
    .dv		    ( uart_dv    ),
    
    .note_num   ( note_num_m ),
    .note_vel 	( note_vel_m ),
    .program 	( program    ),
    .cc_num     ( cc_num     ),
    .cc_val     ( cc_val     ),

    .note_on    ( note_on    ),
    .note_off   ( note_off   ),
    .cc_valid   ( cc_valid   )
);

polyphony polyphony_inst (
    .clk        ( clk         ),
    .ce         ( 1'b1        ),
    .rst        ( rst         ),
    .note_num   ( note_num_m  ),
    .note_vel   ( note_vel_m  ),
    .note_on    ( note_on     ),
    .note_off   ( note_off    ),
    .note_num_0 ( note_num[0] ),
    .note_num_1 ( note_num[1] ),
    .note_num_2 ( note_num[2] ),
    .note_num_3 ( note_num[3] ),
    .note_vel_0 ( note_vel[0] ),
    .note_vel_1 ( note_vel[1] ),
    .note_vel_2 ( note_vel[2] ),
    .note_vel_3 ( note_vel[3] ),
    .gate_on_0  ( gate_on[0]  ),
    .gate_on_1  ( gate_on[1]  ),
    .gate_on_2  ( gate_on[2]  ),
    .gate_on_3  ( gate_on[3]  ),
    .gate_off_0 ( gate_off[0] ),
    .gate_off_1 ( gate_off[1] ),
    .gate_off_2 ( gate_off[2] ),
    .gate_off_3 ( gate_off[3] )
);

cc_decoder cc_decoder_inst (
    .clk ( clk ),
    .rst ( rst ),

    .cc_num   ( cc_num   ),
    .cc_val   ( cc_val   ),
    .cc_valid ( cc_valid ),

    .wtb_load ( wtb_load ),
    .wtb_num  ( {2'd0,wtb_num}),
    .wfm_num  ( {2'd0,wfm_num}),

    .adsr_a ( adsr_a ),
    .adsr_d ( adsr_d ),
    .adsr_s ( adsr_s ),
    .adsr_r ( adsr_r )
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

genvar i;
generate 
    for (i = 0; i < VOICE_NUM; i = i+1)
    begin
        if (i == 0) begin
            wtb_synthesis wtb_synthesis_inst (
                .clk            ( clk             ),
                .sample_rate    ( sample_rate_ceo ),
                .wtb_load       ( wtb_load        ),
                .wtb_num        ( wtb_num         ),   
                .wtb_load_num   ( wtb_load_num    ),
                .wtb_load_done  ( wtb_load_done   ),
                .program        ( wfm_num         ),
                .note_num       ( note_num[i]     ),
                .note_vel       ( note_vel[i]     ),
                .env_scale      ( env_out[i]      ),
                .sample_out     ( out_sample[i]   )
            );
        end
        else begin
            wtb_synthesis wtb_synthesis_inst (
                .clk            ( clk             ),
                .sample_rate    ( sample_rate_ceo ),
                .wtb_load       ( wtb_load        ),
                .wtb_num        ( wtb_num         ),   
                .wtb_load_num   (                 ),
                .wtb_load_done  (                 ),
                .program        ( wfm_num         ),
                .note_num       ( note_num[i]     ),
                .note_vel       ( note_vel[i]     ),
                .env_scale      ( env_out[i]      ),
                .sample_out     ( out_sample[i]   )
            );
        end
    end
endgenerate

genvar j;
generate 
    for (j = 0; j < VOICE_NUM; j = j+1)
    begin
        adsr_top adsr_top_inst (
            .clk ( clk ),
            .rst ( rst ),
            .sample_rate ( sample_rate_ceo ),

            .gate_on  ( gate_on[j]  ),
            .gate_off ( gate_off[j] ),

            .adsr_a ( adsr_a ),
            .adsr_d ( adsr_d ),
            .adsr_s ( adsr_s ),
            .adsr_r ( adsr_r ),
            
            .env_out ( env_out[j] )
        );
    end
endgenerate


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