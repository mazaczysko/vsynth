
module wtb_synthesis (

    input        clk,
    input        sample_rate,

    input        wtb_load,
    input  [4:0] wtb_num,
    output [4:0] wtb_load_num,
    output       wtb_load_done,

    input [6:0] program,
    input [6:0] note_num,
    input [6:0] note_vel,

    output [7:0] sample_out
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
wire [7:0]  output_sample;

assign sample_vel = output_sample * note_vel;
assign sample_out = sample_vel[14:7];


wavetable_loader wtb_loader_inst (
    .clk                    ( clk               ),
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
    .clk         ( clk              ),
    .nco_phase_dv( nco_phase_dv     ),
    .nco_phase   ( nco_phase        ),
    .wfm_num_l   ( wtb_ram_wfm_l_r  ),
    .wfm_num_r   ( wtb_ram_wfm_r_r  ),
    .factor      ( wtb_ram_factor_r ), 
    .sample_out  ( output_sample    )
);

endmodule