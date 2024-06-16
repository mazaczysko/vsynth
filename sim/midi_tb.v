`timescale 1ns / 1ps

module midi_tb;

reg clk;
reg ce;
reg dv;
reg rst;
reg [7:0] data;
wire [6:0] note_num;
wire [6:0] note_vel;
wire [6:0] program;



initial begin
    clk = 0;
    ce = 1;
    rst = 0;
    dv = 0;
    data = 0;
end

always #1 clk = ~clk; 

midi midi1(
    .clk      ( clk      ),
    .ce       ( ce       ),
    .rst      ( rst      ),
    .data     ( data     ),
    .dv       ( dv       ),
    .note_num ( note_num ),
    .note_vel ( note_vel ),
    .program  ( program  )
);

initial begin
    //NOTE ON
    #20 data = 8'h90; //Status note on
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd69; //Note num
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd100; //Note vel
    #2	dv = 1;
    #2 	dv = 0;
    
    #20 data = 8'h80; //Status note off
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd70; //Note num -> WRONG
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd50; //Note vel
    #2	dv = 1;
    #2 	dv = 0;

    #20 data = 8'h80; //Status note off
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd69; //Note num -> GOOD
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd50; //Note vel
    #2	dv = 1;
    #2 	dv = 0;

    #20 data = 8'hc0; //Status program
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd127; //Program
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd50; //Some useless data
    #2	dv = 1;
    #2 	dv = 0;
    
    #20 data = 8'hc0; //Status program
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd30; //Program
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd50; //Some useless data
    #2	dv = 1;
    #2 	dv = 0;
    
    #20 data = 8'hff; //Status RESET
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd30; //Some data bytes
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd50;
    #2	dv = 1;
    #2 	dv = 0;
    
    //NOTE ON
    #20 data = 8'h90; //Status note on
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd69; //Note num
    #2	dv = 1;
    #2 	dv = 0;
    #20	data = 8'd100; //Note vel
    #2	dv = 1;
    #2 	dv = 0;



end


endmodule