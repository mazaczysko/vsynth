`timescale 1ns / 1ps

module adsr_nco_tb;

reg         clk;
reg         rst;
reg   [6:0] env_time;
wire  [6:0] env_scale;
wire        env_ov;
wire        env_dv;
wire        sample_rate;

initial begin
    clk = 0;
    rst = 1;
    env_time = 0;
end

always #5 clk = ~clk; 

prescaler #(
    .MODULO ( 3125 ),
    .W      ( 12   )
)
sample_rate_prescaler
(
    .clk ( clk         ),
    .ce  ( 1'b1        ),
    .ceo ( sample_rate )
);

adsr_nco DUT (
    .clk          ( clk         ),
    .rst          ( rst         ),
    .sample_rate  ( sample_rate ),
    .env_time     ( env_time    ),   
    .env_scale    ( env_scale   ),
    .env_ov       ( env_ov      ),    
    .env_dv       ( env_dv      )
);

initial begin

    repeat(10) @(posedge clk);

    @(posedge clk)
        rst <= 1'b0;

end

always @(posedge clk) begin
    if(env_ovflow && env_dv)
        env_time <= env_time + 1;
end


endmodule