`timescale 1ns / 1ps

module wtb_synthesis_tb;

integer i, j;

reg clk;    

reg        wtb_load;    
reg  [4:0] wtb_num;
wire [4:0] wtb_load_num;
wire       wtb_load_done;

reg [6:0] program;      
reg [6:0] note_num;     

wire [7:0] sample_out;
wire sample_rate_out;


always #5 clk = ~clk;

initial begin

clk <= 1'b0;
wtb_load <= 1'd0;
wtb_num <= 4'd4;
program <= 7'd11;
note_num <= 7'd69;

repeat (4) @(posedge clk);

@(posedge clk)
    wtb_load <= 1'b1;

@(posedge clk)
    wtb_load <= 1'b0;    

@(posedge wtb_load_done)
    $display("wtb_load_done");

for ( i = 0; i < 63; i=i+1 )
begin 
    @(posedge clk) 
        program <= i;
        
    for ( j = 0; j < 128; j=j+1)
    begin
        @(posedge sample_rate_out);
    end
end
@(posedge clk)
    $finish;

end

wtb_synthesis DUT (
    .clk            ( clk             ),
    .wtb_load       ( wtb_load        ),
    .wtb_num        ( wtb_num         ),   
    .wtb_load_num   ( wtb_load_num    ),
    .wtb_load_done  ( wtb_load_done   ),
    .program        ( program         ),
    .note_num       ( note_num        ),
    .sample_out     ( sample_out      ),
    .sample_rate_out( sample_rate_out )
);


endmodule



