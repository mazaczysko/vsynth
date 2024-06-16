`timescale 1ns / 1ps

module wavetable_ram_tb;

parameter RAM_SIZE = 61;

reg clk;

reg        re;
reg  [5:0] addr_r;
wire [7:0] wfm_left_r;
wire [7:0] wfm_right_r;
wire [7:0] factor_r;
wire       is_pure_r;

reg       we;
reg [5:0] addr_w;
reg [7:0] wfm_left_w;
reg [7:0] wfm_right_w;
reg [7:0] factor_w;
reg       is_pure_w;

integer i;

always #5 clk = ~clk;

initial begin

clk <= 1'b0;

re <= 1'b0;
we <= 1'b0;

addr_r <= 6'd0;

addr_w      <= 6'd0;
wfm_left_w  <= 8'hde;
wfm_right_w <= 8'had;
factor_w    <= 8'hbe;
is_pure_w   <= 1'b1;

repeat (4) @(posedge clk);

for( i = 0; i < 61; i=i+1 ) 
begin
    @ (posedge clk)
    begin
        we          <= 1'b1;
        addr_w      <= i;
        if(i%2 == 0)
        begin
            wfm_left_w  <= 8'hbe;
            wfm_right_w <= 8'had;
            factor_w    <= 8'hde;
            is_pure_w   <= 1'b0;
        end
        else
        begin
            wfm_left_w  <= 8'haf;
            wfm_right_w <= 8'hdc;
            factor_w    <= 8'had;
            is_pure_w   <= 1'b1;
        end
    end
end

@(posedge clk)
    we <= 1'b0;

for( i = 0; i < 61; i=i+1 ) 
begin
    @ (posedge clk)
    begin
        re          <= 1'b1;
        addr_r      <= i;
    end
end

for( i = 0; i < 61; i=i+1 ) 
begin
    @ (posedge clk)
    begin
        re          <= 1'b0;
        we          <= 1'b1;
        addr_r      <= i;
        addr_w      <= i;
        if(i%2 == 0)
        begin
            wfm_left_w  <= 8'h00;
            wfm_right_w <= 8'h00;
            factor_w    <= 8'h00;
            is_pure_w   <= 1'b0;
        end
        else
        begin
            wfm_left_w  <= 8'hff;
            wfm_right_w <= 8'hff;
            factor_w    <= 8'hff;
            is_pure_w   <= 1'b1;
        end
    end
end


for( i = 0; i < 61; i=i+1 ) 
begin
    @ (posedge clk)
    begin
        re          <= 1'b1;
        addr_r      <= i;
    end
end

for( i = 0; i < 61; i=i+1 ) 
begin
    @ (posedge clk)
    begin
        re          <= 1'b0;
        addr_r      <= i;
    end
end

for( i = 0; i < 61; i=i+1 ) 
begin
    @ (posedge clk)
    begin
        re          <= 1'b0;
        we          <= 1'b0;
        addr_w      <= i;

        wfm_left_w  <= 8'h00;
        wfm_right_w <= 8'h00;
        factor_w    <= 8'h00;
        is_pure_w   <= 1'b0;

    end
end

for( i = 0; i < 61; i=i+1 ) 
begin
    @ (posedge clk)
    begin
        re          <= 1'b1;
        addr_r      <= i;
    end
end

for( i = 0; i < 61; i=i+1 ) 
begin
    @ (posedge clk)
    begin
        re          <= 1'b0;
        we          <= 1'b1;
        addr_w      <= i;

        wfm_left_w  <= 8'h00;
        wfm_right_w <= 8'h00;
        factor_w    <= 8'h00;
        is_pure_w   <= 1'b0;

    end
end

for( i = 0; i < 61; i=i+1 ) 
begin
    @ (posedge clk)
    begin
        re          <= 1'b1;
        addr_r      <= i;
    end
end

$finish;

end

wavetable_ram dut (
    .clk              (clk          ),
    
    .re               (re           ),
    .addr_r           (addr_r       ),
    .waveform_left_r  (wfm_left_r   ),
    .waveform_right_r (wfm_right_r  ),
    .factor_r         (factor_r     ),
    .is_pure_r        (is_pure_r    ),
    
    .we               (we           ),
    .addr_w           (addr_w       ),
    .waveform_left_w  (wfm_left_w   ),
    .waveform_right_w (wfm_right_w  ),
    .factor_w         (factor_w     ),
    .is_pure_w        (is_pure_w    ) 

);




endmodule