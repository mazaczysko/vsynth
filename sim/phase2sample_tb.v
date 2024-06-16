`timescale 1ns / 1ps

module phase2sample_tb;

integer i;

reg clk;
reg ce;

reg [7:0] wfm_num_l;
reg [7:0] wfm_num_r;
reg [7:0] factor;

reg  [6:0] nco_phase;
wire [7:0] sample_out;

always #5 clk = ~clk;

initial begin

i=0;
clk <= 1'b0;
ce  <= 1'b0;
wfm_num_l <= 8'd0;
wfm_num_r <= 8'd0;
factor    <= 8'd0;

repeat (4) @(posedge clk);

for(i = 0; i < 128; i=i+1 )
begin
    @(posedge clk)
    begin
        ce        <= 1'b1;
        factor    <= 8'h6a;
        wfm_num_r <= 8'h4b;
        wfm_num_l <= 8'h4a;
        nco_phase <= i;
    end
end

@(posedge clk)
    ce <= 1'b0;

repeat (16) @(posedge clk);

for(i = 0; i < 128; i=i+1 )
begin
    @(posedge clk)
    begin
        ce        <= 1'b1;
        factor    <= 8'hcf;
        wfm_num_r <= 8'h2d;
        wfm_num_l <= 8'h2c;
        nco_phase <= i;
    end
end

@(posedge clk)
    $finish;

end

phase2sample DUT ( 
    .clk        (clk        ),
    .ce         (ce         ),
    .nco_phase  (nco_phase  ),
    .wfm_num_l  (wfm_num_l  ),
    .wfm_num_r  (wfm_num_r  ),
    .factor     (factor     ), 
    .sample_out (sample_out )
);


endmodule




