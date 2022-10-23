`timescale 1ns / 1ps

module poly_midi;

reg CLK, CE, RST, dv;
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
    CLK = 0;
    CE = 0;
    RST = 1;
    data = 0;
    dv = 0;
end

always #1 CLK = ~CLK;

midi interprter(
    .CLK(CLK),
    .CE(CE),
    .RST(RST),
    .CHANNEL(4'd0),
    .DATA(data),
    .DV(dv),
    .NOTE_NUM(note_num_out),
    .NOTE_VEL(note_vel_out),
    .PROGRAM(program_out),
    .NOTE_ON_OUT(note_on_out),
    .NOTE_OFF_OUT(note_off_out)
);

polyphony poly(
    .CLK(CLK),
    .CE(CE),
    .RST(RST),
    .NOTE_NUM(note_num_out),
    .NOTE_VEL(note_vel_out),
    .NOTE_ON(note_on_out),
    .NOTE_OFF(note_off_out),
    .NOTE_NUM_0(note_num_0_out),
    .NOTE_NUM_1(note_num_1_out),
    .NOTE_NUM_2(note_num_2_out),
    .NOTE_NUM_3(note_num_3_out),
    .NOTE_VEL_0(note_vel_0_out),
    .NOTE_VEL_1(note_vel_1_out),
    .NOTE_VEL_2(note_vel_2_out),
    .NOTE_VEL_3(note_vel_3_out)
);

initial begin
CE = 1;
#5 RST <= 0;

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
