`timescale 1ns / 1ps

module up_cnt_mod_load_tb;

parameter RAM_SIZE = 61;

reg        clk;
reg        ce;
reg        load;
reg  [3:0] ld_data;
wire [3:0] cnt_out; 
wire       co_out;

integer i;

always #5 clk = ~clk;

initial 
begin

i = 0;

clk <= 1'b0;
ce  <= 1'b0;

repeat(4) @(posedge clk);

$display("Loading 4'h0");

@(posedge clk)
begin
    ld_data <= 4'h0;
    load    <= 1'b1;
end

$display("cnt_out=0x%0h", cnt_out); 


@(posedge clk)
begin
    load <= 1'b0;
    ce <= 1'b1;
end

repeat (14) @(posedge clk);

$display("Loading 4'h9");

@(posedge clk)
begin
    load <= 1'b1;
    ld_data <= 4'h9;
end

$display("cnt_out=0x%0h", cnt_out); 


repeat (4) @(posedge clk);

for ( i = 0; i < 16 ; i=i+1)
begin

$display("Loading 0x%0h",i);    

    @(posedge clk)
        ld_data <= i;

$display("cnt_out=0x%0h", cnt_out); 

end

@(posedge clk) 
begin
    ce   <= 1'b0;
    load <= 1'b0;
end

repeat (4) @(posedge clk);

@(posedge clk)
    ce <= 1'b1;

repeat (13) @(posedge clk);

@(posedge clk)
begin
    ld_data <= 4'h6;
    load    <= 1'b1;
end

@(posedge clk)
    load <= 1'b0;
   

repeat (10) @(posedge clk);


$finish;

end 

up_cnt_mod_load #(
    .MODULO (10 ),
    .W      (4  )
)
DUT
(
    .clk     (clk       ),
    .ce      (ce        ),
    .load    (load      ),
    .ld_data (ld_data   ),
    .q       (cnt_out   ),
    .co      (co_out    )
);


endmodule