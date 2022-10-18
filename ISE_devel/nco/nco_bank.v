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

wire trig_sample;
wire [3:0] trig_sample_fifo_out;

wire [6:0] note_num_mux_out;

//32kHz sample rate @ 100MHz CLK
prescaler #(
	.MODULO(3125),
	.W(12)
)
sample_rate
(
	.CLK(CLK),
	.CE(CE),
	.CEO(trig_sample)
);

shift_reg_right #(
    .W(5)
)
trig_sample_fifo
(
    .CLK(CLK),
    .CE(CE),
    .CLR(RST),
    .D(trig_sample),
    .Q(trig_sample_fifo_out)
);

mux_4_1_hot1 #(
    .W(7)
)
note_num_mux
(
    .CLK(CLK),
    .CE(CE),
    .SEL({trig_sample,trig_sample_fifo_out[4:2]}), //1 CLK before memory address read (synchronous mux)
    .IN_0(NOTE_NUM_0),
    .IN_1(NOTE_NUM_1),
    .IN_2(NOTE_NUM_2),
    .IN_3(NOTE_NUM_3),
    .OUT(note_num_mux_out)
);

step_size_rom step_rom (
	.CLK(CLK),
	.CE(trig_sample_fifo_out[4:1]), //1 CLK after MUX
	.A(note_num_mux_out),
	.D(step)
);

nco nco_0 (
    .CLK(CLK),
    .CE(CE),
    .TRIG_SAMPLE(trig_sample_fifo_out[3]),
    
);

nco nco_1 (
    .CLK(CLK),
    .CE(CE),
    .TRIG_SAMPLE(trig_sample_fifo_out[2]),
    
);

nco nco_2 (
    .CLK(CLK),
    .CE(CE),
    .TRIG_SAMPLE(trig_sample_fifo_out[1]),
    
);

nco nco_3 (
    .CLK(CLK),
    .CE(CE),
    .TRIG_SAMPLE(trig_sample_fifo_out[0]),
    
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
                OUT <= IN_0;

            4'b0010:
                OUT <= IN_0;

            4'b0001:
                OUT <= IN_0;
            
            default:
                OUT <= OUT;        
        endcase

endmodule