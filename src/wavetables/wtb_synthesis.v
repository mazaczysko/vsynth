
module wtb_synthesis (

    input        clk,
    input        rst,
    input        sample_rate,

    input        wtb_load,
    input  [4:0] wtb_num,
    output [4:0] wtb_load_num,
    output       wtb_load_done,

    input [6:0] program,
    input [6:0] note_num,
    input [6:0] note_vel,
    input [6:0] env_scale,

    output [7:0] sample_out,
    output       sample_out_dv
);

wire [3:0] wtb_ram_we;
wire [5:0] wtb_ram_addr_w;  
wire [7:0] wtb_ram_wfm_l_w; 
wire [7:0] wtb_ram_wfm_r_w; 
wire [7:0] wtb_ram_factor_w;

wire [5:0] wtb_ram_addr_r;  
wire [7:0] wtb_ram_wfm_l_r; 
wire [7:0] wtb_ram_wfm_r_r; 
wire [7:0] wtb_ram_factor_r;

wire [6:0] nco_phase;
wire       nco_phase_dv;

wire [14:0] sample_vel;
wire        sample_vel_dv;

wire [7:0]  sample_vel_out;
wire [14:0] sample_env;

wire [7:0] phase_sample;
wire       phase_sample_dv;

assign sample_out = sample_env[14:7];
assign sample_out_dv = sample_env_dv;

simple_mul #(
    .WIDTH_A (8),
    .WIDTH_B (7)
)
sample_note_vel_mul
(
    .clk    ( clk             ),
    .rst    ( rst             ),
    .ce     ( phase_sample_dv ),
    .a      ( phase_sample    ),
    .b      ( note_vel        ),
    .res    ( sample_vel      ),
    .res_dv ( sample_vel_dv   )
);

simple_mul #(
    .WIDTH_A (8),
    .WIDTH_B (7)
)
sample_env_vel_mul
(
    .clk    ( clk              ),
    .rst    ( rst              ),
    .ce     ( sample_vel_dv    ),
    .a      ( sample_vel[14:7] ),
    .b      ( env_scale        ),
    .res    ( sample_env       ),
    .res_dv ( sample_env_dv    )
);

wavetable_loader wtb_loader_inst (
    .clk                    ( clk               ),
    .rst                    ( rst               ),
    .wtb_num                ( wtb_num           ),
    .wtb_load               ( wtb_load          ),
    .voice_num              ( 2'd0              ),
    .wtb_ram_we             ( wtb_ram_we        ),
    .wtb_ram_addr_w         ( wtb_ram_addr_w    ),
    .wtb_ram_wfm_l_w        ( wtb_ram_wfm_l_w   ),
    .wtb_ram_wfm_r_w        ( wtb_ram_wfm_r_w   ),
    .wtb_ram_factor_w       ( wtb_ram_factor_w  ),
    .done_wtb_num           ( wtb_load_num      ),
    .done                   ( wtb_load_done     ),
    .idle                   (                   )
);

wavetable_ram wavetable_ram_inst (
    .clk ( clk  ),
 
    .re               ( 1'b1             ),
    .addr_r           ( program[5:0]     ),
    .waveform_left_r  ( wtb_ram_wfm_l_r  ),
    .waveform_right_r ( wtb_ram_wfm_r_r  ),
    .factor_r         ( wtb_ram_factor_r ),

    .we               ( wtb_ram_we[0]     ),
    .addr_w           ( wtb_ram_addr_w    ),
    .waveform_left_w  ( wtb_ram_wfm_l_w   ),
    .waveform_right_w ( wtb_ram_wfm_r_w   ),
    .factor_w         ( wtb_ram_factor_w  )
);

nco nco_inst (
    .clk         ( clk             ),
    .sample_rate ( sample_rate     ),
    .note_num    ( note_num        ),
    .phase       ( nco_phase       ),
    .phase_dv    ( nco_phase_dv    )
);

phase2sample phase2sample_inst ( 
    .clk           ( clk              ),
    .nco_phase_dv  ( nco_phase_dv     ),
    .nco_phase     ( nco_phase        ),
    .wfm_num_l     ( wtb_ram_wfm_l_r  ),
    .wfm_num_r     ( wtb_ram_wfm_r_r  ),
    .factor        ( wtb_ram_factor_r ), 
    .sample_out    ( phase_sample     ),
    .sample_out_dv ( phase_sample_dv  )
);

endmodule