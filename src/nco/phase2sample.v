module phase2sample ( 
    input        clk        ,
    input        ce         ,
    input       [6:0] nco_phase  ,
    input       [7:0] wfm_num_l  ,
    input       [7:0] wfm_num_r  ,
    input       [7:0] factor     , 
    output reg  [7:0] sample_out 
);

reg [7:0] factor_reg;

//64 Samples in wave and wave mirroring
wire half_select;
wire [5:0] half_phase;

wire [5:0] phase;

wire  [7:0] sample_l;
wire  [7:0] sample_r;
wire  [7:0] sample_l_final;
wire  [7:0] sample_r_final;
wire [15:0] mix_l;
wire [15:0] mix_r;
wire  [8:0] factor_subtracted;
wire  [7:0] sample_final;

assign half_select = nco_phase[6];
assign half_phase = nco_phase[5:0];
assign phase = half_select ? 6'd63 - half_phase : half_phase;

assign sample_l_final = half_select ? 8'd255 - sample_l : sample_l;
assign sample_r_final = half_select ? 8'd255 - sample_r : sample_r;

assign factor_subtracted = 9'd256 - factor_reg;

assign mix_l = factor_subtracted * sample_l_final;
assign mix_r = factor_reg * sample_r_final;

assign sample_final = mix_l[15:8] + mix_r[15:8];

always @(posedge clk)
    if(ce)
        sample_out <= sample_final;

always @(posedge clk)
    if(ce)
        factor_reg <= factor;

sample_rom sample_rom_inst (
    .clk           (clk        ),
    .re_a          (ce         ),
    .addr_a_sample (phase      ),
    .addr_a_wfm    (wfm_num_l  ),
    .data_a        (sample_l   ),
    .re_b          (ce         ),
    .addr_b_sample (phase      ),
    .addr_b_wfm    (wfm_num_r  ),
    .data_b        (sample_r   )  
);


endmodule