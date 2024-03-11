module nco (
	input         clk         ,
	input         ce          ,
	input         trig_read   ,
	input  [15:0] step_size   , //input of phase adder
	input  [6:0]  note_vel    ,
	input         trig_sample ,
	input  [7:0]  prog_sample ,
	output [6:0]  phase       ,
	output [7:0]  sample_out
);

wire [7:0]  sample;
wire [15:0] sample_vel;
wire [7:0]  output_sample = sample_vel[14:7];

wire [15:0] phase_add_out;  //output of phase adder
wire [15:0] phase_reg_out;  //input of phase adder

assign sample_vel = prog_sample * note_vel;

assign phase  = phase_reg_out[15:9];
//assign phase  = phase_reg_out[7:0]; //for simulation

assign phase_add_out = phase_reg_out + step_size;

register #(
    .W(16)
)
phase_reg
(
    .clk ( clk           ),
    .ce  ( trig_read     ),
    .d   ( phase_add_out ),
    .q   ( phase_reg_out )
);

register #(
    .W(8)
)
sample_out_reg
(
    .clk ( clk           ),
    .ce  ( trig_sample   ),
    .d   ( output_sample ),
    .q   ( sample_out    )
);


endmodule
