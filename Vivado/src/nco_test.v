module nco_test (
    input CLK,
    input [6:0] NOTE_NUM,
    input [6:0] NOTE_VEL,
    input [1:0] PROGRAM,
    output [7:0] SAMPLE,
    output TRIG
);

nco osc (
    .CLK(CLK),
    .CE(1'd1),
    .NOTE_NUM(NOTE_NUM),
    .NOTE_VEL(NOTE_VEL),
    .PROGRAM({5'd0, PROGRAM}),
    .SAMPLE_OUT(SAMPLE),
    .TRIG(TRIG)
);


endmodule