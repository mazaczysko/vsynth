`timescale 1ns / 1ps

module wavetable_loader_tb;

parameter RAM_SIZE = 61;

reg clk;

reg wtb_load;

wire [3:0] wtb_ram_we;      
wire [5:0] wtb_ram_addr_w;  
wire [7:0] wtb_ram_wfm_l_w;
wire [7:0] wtb_ram_wfm_r_w;
wire [7:0] wtb_ram_factor_w; 

always #5 clk = ~clk;

initial begin

clk <= 1'b0;
wtb_load <= 1'b0;

repeat (4) @(posedge clk);

@(posedge clk)
    wtb_load <= 1'b1;

@(posedge clk)
    wtb_load <= 1'b0;


end

wavetable_loader dut (
    .clk              ( clk  ),             
    
    .wtb_num          ( 5'h00       ),
    .wtb_load         ( wtb_load    ),    
    .voice_num        ( 4'h0        ),
    
    .wtb_ram_we       ( wtb_ram_we       ),
    .wtb_ram_addr_w   ( wtb_ram_addr_w   ),
    .wtb_ram_wfm_l_w  ( wtb_ram_wfm_l_w  ),
    .wtb_ram_wfm_r_w  ( wtb_ram_wfm_r_w  ),
    .wtb_ram_factor_w ( wtb_ram_factor_w )
);


wavetable_ram dut2 (
    .clk              (clk          ),
    
    .re               (1'b0          ),
    .addr_r           (              ),
    .waveform_left_r  (              ),
    .waveform_right_r (              ),
    .factor_r         (              ),
    
    .we               (wtb_ram_we[0]    ),
    .addr_w           (wtb_ram_addr_w   ),
    .waveform_left_w  (wtb_ram_wfm_l_w  ),
    .waveform_right_w (wtb_ram_wfm_r_w  ),
    .factor_w         (wtb_ram_factor_w )
);


endmodule




