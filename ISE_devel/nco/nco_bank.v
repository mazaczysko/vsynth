module nco_bank (
    input CLK,
    input CE,
    input RST,
    input [6:0] PROGRAM,
    input [6:0] NOTE_NUM_0,
    input [6:0] NOTE_NUM_1,
    input [6:0] NOTE_NUM_2,
    input [6:0] NOTE_NUM_3,
    input [6:0] NOTE_VEL_0,
    input [6:0] NOTE_VEL_1,
    input [6:0] NOTE_VEL_2,
    input [6:0] NOTE_VEL_3,
    output [7:0] SAMPLE_SUM_OUT
);


wire [15:0] step_size;
wire [7:0] sampler_out;
wire [6:0] note_num_mux_out;
wire [6:0] phase_mux_out;

wire [6:0] phase_0;
wire [6:0] phase_1;
wire [6:0] phase_2;
wire [6:0] phase_3;

wire [7:0] sample_0;
wire [7:0] sample_1;
wire [7:0] sample_2;
wire [7:0] sample_3;

wire trig;
wire [8:0] trig_fifo_out;
wire [9:0] trig_fifo = {trig, trig_fifo_out};

wire note_num_mux_ce;
wire [3:0] note_num_mux_sel;
wire step_rom_ce;
wire trig_read_0, trig_read_1, trig_read_2, trig_read_3;
wire phase_mux_ce;
wire [3:0] phase_mux_sel;
wire sampler_ce;
wire trig_sample_0, trig_sample_1, trig_sample_2, trig_sample_3, trig_sample_out;

wire [7:0] sample_sum_divided_8bit;
wire [11:0] sample_sum;

assign note_num_mux_ce = |trig_fifo[9:6];
assign note_num_mux_sel = trig_fifo[9:6];
assign step_rom_ce = |trig_fifo[8:5];
assign trig_read_0 = trig_fifo[7];
assign trig_read_1 = trig_fifo[6];
assign trig_read_2 = trig_fifo[5];
assign trig_read_3 = trig_fifo[4]; 
assign phase_mux_ce = |trig_fifo[6:3];
assign phase_mux_sel = trig_fifo[6:3];
assign sampler_ce = |trig_fifo[5:2];
assign trig_sample_0 = trig_fifo[4];
assign trig_sample_1 = trig_fifo[3];
assign trig_sample_2 = trig_fifo[2];
assign trig_sample_3 = trig_fifo[1];
assign trig_sample_out = trig_fifo[0];

assign sample_sum = sample_0 + sample_1 + sample_2 + sample_3;
assign sample_sum_divided_8bit = sample_sum[9:2]; 

//Output sample register
register_clr #(
    .W(8)
)
sample_sum_reg
(
    .CLK(CLK),
    .CE(trig_sample_out),
    .CLR(RST),
    .D(sample_sum_divided_8bit),
    .Q(SAMPLE_SUM_OUT)
);


//32kHz sample rate @ 100MHz CLK
prescaler #(
	.MODULO(3125),
	//.MODULO(30), //For simulation
	.W(12)
)
sample_rate
(
	.CLK(CLK),
	.CE(CE),
	.CEO(trig)
);

shift_reg_right #(
    .W(9)
)
trig_fifo_reg
(
    .CLK(CLK),
    .CE(CE),
    .CLR(RST),
    .D(trig),
    .Q(trig_fifo_out)
);

mux_4_1_hot1 #(
    .W(7)
)
note_num_mux
(
    .CLK(CLK),
    .CE(note_num_mux_ce),
    .SEL(note_num_mux_sel), 
    .IN_0(NOTE_NUM_0),
    .IN_1(NOTE_NUM_1),
    .IN_2(NOTE_NUM_2),
    .IN_3(NOTE_NUM_3),
    .OUT(note_num_mux_out)
);

step_size_rom step_rom (
	.CLK(CLK),
	.CE(step_rom_ce),
	.A(note_num_mux_out),
	.D(step_size)
);

mux_4_1_hot1 #(
    .W(7)
)
phase_mux
(
    .CLK(CLK),
    .CE(phase_mux_ce),
    .SEL(phase_mux_sel),
    .IN_0(phase_0),
    .IN_1(phase_1),
    .IN_2(phase_2),
    .IN_3(phase_3),
    .OUT(phase_mux_out)
);

phase2sample sampler (
    .CLK(CLK),
    .CE(sampler_ce), 
    .PHASE(phase_mux_out),
    .PROGRAM(PROGRAM),
    .SAMPLE_OUT(sampler_out)
);

nco nco_0 (
    .CLK(CLK),
    .CE(CE),
    .TRIG_READ(trig_read_0),
    .STEP_SIZE(step_size),
    .NOTE_VEL(NOTE_VEL_0),
    .TRIG_SAMPLE(trig_sample_0),
    .PROG_SAMPLE(sampler_out),
    .PHASE(phase_0),
    .SAMPLE_OUT(sample_0)
);

nco nco_1 (
    .CLK(CLK),
    .CE(CE),
    .TRIG_READ(trig_read_1),
    .STEP_SIZE(step_size),
    .NOTE_VEL(NOTE_VEL_1),
    .TRIG_SAMPLE(trig_sample_1),    
    .PROG_SAMPLE(sampler_out),
    .PHASE(phase_1),
    .SAMPLE_OUT(sample_1)
);

nco nco_2 (
    .CLK(CLK),
    .CE(CE),
    .TRIG_READ(trig_read_2),
    .STEP_SIZE(step_size),
    .NOTE_VEL(NOTE_VEL_2),
    .TRIG_SAMPLE(trig_sample_2),
    .PROG_SAMPLE(sampler_out),
    .PHASE(phase_2),
    .SAMPLE_OUT(sample_2)
);

nco nco_3 (
    .CLK(CLK),
    .CE(CE),
    .TRIG_READ(trig_read_3),
    .STEP_SIZE(step_size),
    .NOTE_VEL(NOTE_VEL_3),
    .TRIG_SAMPLE(trig_sample_3),
    .PROG_SAMPLE(sampler_out),
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