`timescale 1ns / 1ps

module adsr_top_tb;

reg         clk;
reg         rst;
wire        sample_rate;

reg gate_on;
reg gate_off;
reg [6:0] adsr_a;
reg [6:0] adsr_d;
reg [6:0] adsr_s;
reg [6:0] adsr_r;

wire [6:0] env_out;

reg  [6:0] env_out_r;

initial begin
    clk = 0;
    rst = 1;
    
    gate_on = 0;
    gate_off = 0;

    adsr_a = 2;
    adsr_d = 4;
    adsr_s = 64;
    adsr_r = 5;
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

adsr_top DUT (
    .clk ( clk ),
    .rst ( rst ),
    .sample_rate ( sample_rate ),
    
    .gate_on  ( gate_on  ),
    .gate_off ( gate_off ),

    .adsr_a ( adsr_a ),
    .adsr_d ( adsr_d ),
    .adsr_s ( adsr_s ),
    .adsr_r ( adsr_r ),
    
    .env_out ( env_out )
);


initial begin

    repeat(10) @(posedge clk);

    @(posedge clk)
        rst <= 1'b0;

    repeat(10) @(posedge clk);

    @(posedge clk)
        gate_on <= 1'b1;

    @(posedge clk)
        gate_on <= 1'b0;

    #10000000

    @(posedge clk)
        gate_off <= 1'b1;

    @(posedge clk)
        gate_off <= 1'b0;

end

always @(posedge clk)
    if(sample_rate)
        env_out_r <= env_out;


endmodule