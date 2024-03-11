`timescale 1ns / 1ps

module poly_midi_tb;

reg clk, ce, rst, dv;
reg [7:0] data;

wire note_off_out;
wire note_on_out;

wire [6:0] note_num_out;
wire [6:0] note_vel_out;
wire [6:0] program_out;

wire [6:0] note_num_0_out;
wire [6:0] note_num_1_out;
wire [6:0] note_num_2_out;
wire [6:0] note_num_3_out;

wire [6:0] note_vel_0_out;
wire [6:0] note_vel_1_out;
wire [6:0] note_vel_2_out;
wire [6:0] note_vel_3_out;

initial begin
    clk = 0;
    ce = 0;
    rst = 1;
    data = 0;
    dv = 0;
end

always #1 clk = ~clk;

midi interprter(
    .clk          ( clk             ),
    .ce           ( ce              ),
    .rst          ( rst             ),
    .channel      ( 4'd0            ),
    .data         ( data            ),
    .dv           ( dv              ),
    .note_num     ( note_num_out    ),
    .note_vel     ( note_vel_out    ),
    .PROGRAM      ( program_out     ),
    .note_on_out  ( note_on_out     ),
    .note_off_out ( note_off_out    )
);

polyphony poly(
    .clk        ( clk               ),
    .ce         ( ce                ),
    .rst        ( rst               ),
    .note_num   ( note_num_out      ),
    .note_vel   ( note_vel_out      ),
    .note_on    ( note_on_out       ),
    .note_off   ( note_off_out      ),
    .note_num_0 ( note_num_0_out    ),
    .note_num_1 ( note_num_1_out    ),
    .note_num_2 ( note_num_2_out    ),
    .note_num_3 ( note_num_3_out    ),
    .note_vel_0 ( note_vel_0_out    ),
    .note_vel_1 ( note_vel_1_out    ),
    .note_vel_2 ( note_vel_2_out    ),
    .note_vel_3 ( note_vel_3_out    )
);

initial begin
ce = 1;
#5 rst <= 0;

//note on 0
#4 data <= 8'h90;
   dv <= 1'd1;
#2 dv <= 1'd0;

#4 data <= 8'd10;
    dv <= 1'd1;
#2  dv <= 1'd0;

#4 data <= 8'd127;
    dv <= 1'd1;
#2  dv <= 1'd0;


//note on 1
#4 data <= 8'h90;
   dv <= 1'd1;
#2 dv <= 1'd0;

#4 data <= 8'd11;
    dv <= 1'd1;
#2  dv <= 1'd0;

#4 data <= 8'd127;
    dv <= 1'd1;
#2  dv <= 1'd0;

//note on 2
#4 data <= 8'h90;
   dv <= 1'd1;
#2 dv <= 1'd0;

#4 data <= 8'd12;
    dv <= 1'd1;
#2  dv <= 1'd0;

#4 data <= 8'd127;
    dv <= 1'd1;
#2  dv <= 1'd0;

//note on 3
#4 data <= 8'h90;
   dv <= 1'd1;
#2 dv <= 1'd0;

#4 data <= 8'd13;
    dv <= 1'd1;
#2  dv <= 1'd0;

#4 data <= 8'd127;
    dv <= 1'd1;
#2  dv <= 1'd0;

//note on out of range
#4 data <= 8'h90;
   dv <= 1'd1;
#2 dv <= 1'd0;

#4 data <= 8'd15;
    dv <= 1'd1;
#2  dv <= 1'd0;

#4 data <= 8'd127;
    dv <= 1'd1;
#2  dv <= 1'd0;


//Note 0 off
#6 data <= 8'h80;
   dv <= 1'd1;
#2 dv <= 1'd0;

#4 data <= 8'd10;
    dv <= 1'd1;
#2  dv <= 1'd0;

#4 data <= 8'd127;
    dv <= 1'd1;
#2  dv <= 1'd0;


//Note 0 on
#4 data <= 8'h90;
   dv <= 1'd1;
#2 dv <= 1'd0;

#4 data <= 8'd14;
    dv <= 1'd1;
#2  dv <= 1'd0;

#4 data <= 8'd127;
    dv <= 1'd1;
#2  dv <= 1'd0;



end


endmodule
