`timescale 1ns / 1ps

module wavetable_loader_tb;

parameter RAM_SIZE = 61;

reg clk;

reg wtb_load;
reg [4:0] wtb_num;

wire [3:0] wtb_ram_we;      
wire [5:0] wtb_ram_addr_w;  
wire [7:0] wtb_ram_wfm_l_w;
wire [7:0] wtb_ram_wfm_r_w;
wire [7:0] wtb_ram_factor_w; 

wire [4:0] done_wtb_num;
wire       done;
wire       idle;

always #5 clk = ~clk;

initial begin

clk <= 1'b0;
wtb_load <= 1'b0;

repeat (4) @(posedge clk);

@(posedge clk)
    wtb_num  <= 5'd0;
    wtb_load <= 1'b1;

@(posedge clk)
    wtb_load <= 1'b0;

@(posedge done)

@(posedge clk)
begin
    wtb_load <= 1'b1;
    wtb_num  <= 5'd1;
end

@(posedge clk)
    wtb_load <= 1'b0;

@(posedge done)
    $finish;

end

wavetable_loader dut (
    .clk              ( clk  ),             
    
    .wtb_num          ( wtb_num     ),
    .wtb_load         ( wtb_load    ),    
    .voice_num        ( 4'h0        ),
    
    .wtb_ram_we       ( wtb_ram_we       ),
    .wtb_ram_addr_w   ( wtb_ram_addr_w   ),
    .wtb_ram_wfm_l_w  ( wtb_ram_wfm_l_w  ),
    .wtb_ram_wfm_r_w  ( wtb_ram_wfm_r_w  ),
    .wtb_ram_factor_w ( wtb_ram_factor_w ),

    .done_wtb_num   ( done_wtb_num       ),
    .done           ( done               ),     
    .idle           ( idle               )
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




