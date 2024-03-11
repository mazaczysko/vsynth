module nco_bank (
    input        clk,
    input        ce,
    input        rst,
    input  [6:0] program,
    input  [6:0] note_num_0,
    input  [6:0] note_num_1,
    input  [6:0] note_num_2,
    input  [6:0] note_num_3,
    input  [6:0] note_vel_0,
    input  [6:0] note_vel_1,
    input  [6:0] note_vel_2,
    input  [6:0] note_vel_3,
    output [7:0] sample_sum_out
);


wire [15:0] step_size;
wire [7:0]  sampler_out;
wire [6:0]  note_num_mux_out;
wire [6:0]  phase_mux_out;

wire [6:0] phase_0;
wire [6:0] phase_1;
wire [6:0] phase_2;
wire [6:0] phase_3;

wire [7:0] sample_0;
wire [7:0] sample_1;
wire [7:0] sample_2;
wire [7:0] sample_3;

wire       trig;
wire [8:0] trig_fifo_out;
wire [9:0] trig_fifo = {trig, trig_fifo_out};

wire note_num_mux_ce;
wire [3:0] note_num_mux_sel;
wire step_rom_ce;
wire trig_read_0, trig_read_1, trig_read_2, trig_read_3;
wire phase_mux_ce;
wire [3:0] phase_mux_sel;
wire sampler_ce;
wire trig_sample_0, trig_sample_1, trig_sample_2, trig_sample_3, trig_sample_out;

wire [7:0]  sample_sum_divided_8bit;
wire [11:0] sample_sum;

assign note_num_mux_ce  = |trig_fifo[9:6]   ;
assign note_num_mux_sel = trig_fifo[9:6]    ;
assign step_rom_ce      = |trig_fifo[8:5]   ;
assign trig_read_0      = trig_fifo[7]      ;
assign trig_read_1      = trig_fifo[6]      ;
assign trig_read_2      = trig_fifo[5]      ;
assign trig_read_3      = trig_fifo[4]      ; 
assign phase_mux_ce     = |trig_fifo[6:3]   ;
assign phase_mux_sel    = trig_fifo[6:3]    ;
assign sampler_ce       = |trig_fifo[5:2]   ;
assign trig_sample_0    = trig_fifo[4]      ;
assign trig_sample_1    = trig_fifo[3]      ;
assign trig_sample_2    = trig_fifo[2]      ;
assign trig_sample_3    = trig_fifo[1]      ;
assign trig_sample_out  = trig_fifo[0]      ;

assign sample_sum = sample_0 + sample_1 + sample_2 + sample_3;
assign sample_sum_divided_8bit = sample_sum[9:2]; 

//Output sample register
register_clr #(
    .W(8)
)
sample_sum_reg
(
    .clk ( clk                      ),
    .ce  ( trig_sample_out          ),
    .clr ( rst                      ),
    .d   ( sample_sum_divided_8bit  ),
    .q   ( sample_sum_out           )
);


//32kHz sample rate @ 100MHz clk
prescaler #(
	.MODULO(3125),
	//.MODULO(30), //For simulation
	.W(12)
)
sample_rate
(
	.clk ( clk  ),
	.ce  ( ce   ),
	.ceo ( trig )
);

shift_reg_right #(
    .W(9)
)
trig_fifo_reg
(
    .clk ( clk           ),
    .ce  ( ce            ),
    .clr ( rst           ),
    .d   ( trig          ),
    .q   ( trig_fifo_out )
);

mux_4_1_hot1 #(
    .W(7)
)
note_num_mux
(
    .clk  ( clk              ),
    .ce   ( note_num_mux_ce  ),
    .sel  ( note_num_mux_sel ), 
    .in_0 ( note_num_0       ),
    .in_1 ( note_num_1       ),
    .in_2 ( note_num_2       ),
    .in_3 ( note_num_3       ),
    .out  ( note_num_mux_out )
);

step_size_rom step_rom (
	.clk ( clk              ),
	.ce  ( step_rom_ce      ),
	.a   ( note_num_mux_out ),
	.d   ( step_size        )
);

mux_4_1_hot1 #(
    .W(7)
)
phase_mux
(
    .clk  ( clk             ),
    .ce   ( phase_mux_ce    ),
    .sel  ( phase_mux_sel   ),
    .in_0 ( phase_0         ),
    .in_1 ( phase_1         ),
    .in_2 ( phase_2         ),
    .in_3 ( phase_3         ),
    .out  ( phase_mux_out   )
);

phase2sample sampler (
    .clk        ( clk           ),
    .ce         ( sampler_ce    ), 
    .phase      ( phase_mux_out ),
    .program    ( program       ),
    .sample_out ( sampler_out   )
);

nco nco_0 (
    .clk         ( clk           ),
    .ce          ( ce            ),
    .trig_read   ( trig_read_0   ),
    .step_size   ( step_size     ),
    .note_vel    ( note_vel_0    ),
    .trig_sample ( trig_sample_0 ),
    .prog_sample ( sampler_out   ),
    .phase       ( phase_0       ),
    .sample_out  ( sample_0      )
);

nco nco_1 (
    .clk         ( clk           ),
    .ce          ( ce            ),
    .trig_read   ( trig_read_1   ),
    .step_size   ( step_size     ),
    .note_vel    ( note_vel_1    ),
    .trig_sample ( trig_sample_1 ),    
    .prog_sample ( sampler_out   ),
    .phase       ( phase_1       ),
    .sample_out  ( sample_1      )
);

nco nco_2 (
    .clk         ( clk           ),
    .ce          ( ce            ),
    .trig_read   ( trig_read_2   ),
    .step_size   ( step_size     ),
    .note_vel    ( note_vel_2    ),
    .trig_sample ( trig_sample_2 ),
    .prog_sample ( sampler_out   ),
    .phase       ( phase_2       ),
    .sample_out  ( sample_2      )
);

nco nco_3 (
    .clk         ( clk           ),
    .ce          ( ce            ),
    .trig_read   ( trig_read_3   ),
    .step_size   ( step_size     ),
    .note_vel    ( note_vel_3    ),
    .trig_sample ( trig_sample_3 ),
    .prog_sample ( sampler_out   ),
    .phase       ( phase_3       ),
    .sample_out  ( sample_3      )
);


endmodule