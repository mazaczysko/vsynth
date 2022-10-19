module nco_bank (
    input CLK,
    input CE,
    input RST,
    input [6:0] NOTE_NUM_0,
    input [6:0] NOTE_NUM_1,
    input [6:0] NOTE_NUM_2,
    input [6:0] NOTE_NUM_3,
    input [6:0] NOTE_VEL_0,
    input [6:0] NOTE_VEL_1,
    input [6:0] NOTE_VEL_2,
    input [6:0] NOTE_VEL_3,
    input [6:0] PROGRAM,
    output [7:0] SAMPLE_SUM_OUT
);

wire trig_read;
wire [15:0] step_size;
wire [7:0] prog_sample;
wire [3:0] trig_read_fifo_out;
wire [6:0] note_num_mux_out;


wire trig_read_0, trig_read_1, trig_read_2, trig_read_3;

assign trig_read_0 = trig_read_fifo_out[3];
assign trig_read_1 = trig_read_fifo_out[2];
assign trig_read_2 = trig_read_fifo_out[1];
assign trig_read_3 = trig_read_fifo_out[0]; 

wire [6:0] phase_0;
wire [6:0] phase_1;
wire [6:0] phase_2;
wire [6:0] phase_3;


//32kHz sample rate @ 100MHz CLK
prescaler #(
	.MODULO(3125),
	.W(12)
)
sample_rate
(
	.CLK(CLK),
	.CE(CE),
	.CEO(trig_read)
);

shift_reg_right #(
    .W(5)
)
trig_read_fifo
(
    .CLK(CLK),
    .CE(CE),
    .CLR(RST),
    .D(trig_read),
    .Q(trig_read_fifo_out)
);

mux_4_1_hot1 #(
    .W(7)
)
note_num_mux
(
    .CLK(CLK),
    .CE(CE),
    .SEL({trig_read,trig_read_fifo_out[4:2]}), //1 CLK before memory address read (synchronous mux)
    .IN_0(NOTE_NUM_0),
    .IN_1(NOTE_NUM_1),
    .IN_2(NOTE_NUM_2),
    .IN_3(NOTE_NUM_3),
    .OUT(note_num_mux_out)
);

step_size_rom step_rom (
	.CLK(CLK),
	.CE(trig_read_fifo_out[4:1]), //1 CLK after MUX
	.A(note_num_mux_out),
	.D(step_size)
);

mux_4_1_hot1 #(
    .W(7)
)
phase_mux
(
    .CLK(CLK),
    .CE(CE),
    .SEL({trig_read,trig_read_fifo_out[4:2]}), //1 CLK before memory address read (synchronous mux)
    .IN_0(phase_0),
    .IN_1(phase_1),
    .IN_2(phase_2),
    .IN_3(phase_3),
    .OUT(phase_mux_out)
);

phase2sample sampler (
    .CLK(CLK),
    .CE(trig_read_fifo_out[4:1]), 
    .PHASE(phase_mux_out),
    .PROGRAM(PROGRAM),
    .SAMPLE_OUT(prog_sample)
);

nco nco_0 (
    .CLK(CLK),
    .CE(CE),
    .TRIG_READ(trig_read_0),
    .STEP_SIZE(step_size),
    .NOTE_VEL(NOTE_VEL_0),
    .PROG_SAMPLE(prog_sample),
    .PHASE(phase_0),
    .SAMPLE_OUT(sample_0)
);

nco nco_1 (
    .CLK(CLK),
    .CE(CE),
    .TRIG_READ(trig_read_1),
    .STEP_SIZE(step_size),
    .NOTE_VEL(NOTE_VEL_1),
    .PROG_SAMPLE(prog_sample),
    .PHASE(phase_1),
    .SAMPLE_OUT(sample_1)
);

nco nco_2 (
    .CLK(CLK),
    .CE(CE),
    .TRIG_READ(trig_read_2),
    .STEP_SIZE(step_size),
    .NOTE_VEL(NOTE_VEL_2),
    .PROG_SAMPLE(prog_sample),
    .PHASE(phase_2),
    .SAMPLE_OUT(sample_2)
);

nco nco_3 (
    .CLK(CLK),
    .CE(CE),
    .TRIG_READ(trig_read_3),
    .STEP_SIZE(step_size),
    .NOTE_VEL(NOTE_VEL_3),
    .PROG_SAMPLE(prog_sample),
    .PHASE(phase_3),
    .SAMPLE_OUT(sample_3)
);


endmodule

module mux_4_1_hot1 #( 
    parameter W = 8
)
(
    input CLK,
    input CE,
    input [3:0] SEL,
    input [W-1:0] IN_0,
    input [W-1:0] IN_1,
    input [W-1:0] IN_2,
    input [W-1:0] IN_3,
    output reg [W-1:0] OUT
);

always @(posedge CLK)
    if (CE)
        case (SEL) 
            4'b1000:
                OUT <= IN_0;

            4'b0100:
                OUT <= IN_1;

            4'b0010:
                OUT <= IN_2;

            4'b0001:
                OUT <= IN_3;
            
            default:
                OUT <= OUT;        
        endcase

endmodule