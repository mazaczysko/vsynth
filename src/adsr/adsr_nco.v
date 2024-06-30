module adsr_nco (
    input         clk         ,
    input         rst         ,
    input         sample_rate ,
    input  [6:0]  env_time    ,   
    output [6:0]  env_scale   ,
    output        env_ov      ,    
    output reg    env_dv
);

localparam NCO_W = 24;
localparam STEP_W = 19;

wire phase_reg_clr;

wire [STEP_W-1:0] step_size;
wire [NCO_W-1:0]  phase_add_out;
wire [NCO_W-1:0]  phase_reg_out;

assign env_scale  = phase_reg_out[NCO_W-1:NCO_W-7];
assign phase_add_out = phase_reg_out + step_size;
assign phase_reg_clr = rst || (env_dv && env_ov);

assign env_ov = (phase_add_out < phase_reg_out) && env_dv; 

always @(posedge clk)
    if (rst)
        env_dv <= 1'b0;
    else
        env_dv <= sample_rate;

register_clr #(
    .W(NCO_W)
)
phase_reg
(
    .clk ( clk           ),
    .clr ( phase_reg_clr ),
    .ce  ( sample_rate   ),
    .d   ( phase_add_out ),
    .q   ( phase_reg_out )
);

adsr_nco_step_rom adsr_nco_step_rom_inst (
    .clk  ( clk       ),
    .re   ( 1'b1      ),
    .addr ( env_time  ),
    .data ( step_size )
);

endmodule
