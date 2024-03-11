module midi_test (
	input clk,
	input di,
	output [2:0] note,
	output [2:0] note,
	output [1:0] prog,
	output [7:0] sample_out
);

wire dv;
wire [7:0] uart_out;

wire [6:0] note_num;
wire [6:0] note_note;
wire [6:0] program;

assign note = note_num[2:0];
assign note = note_note[2:0];
assign prog = program[1:0];

uart_rx uart (
	.clk ( clk		),
	.ce  ( 1'd1		),
	.rst ( 1'd0		),
	.di  ( di		),
	.dv  ( dv		),
	.po  ( uart_out	)
);

midi midi1(
	.clk	   ( clk		),
	.ce   	   ( 1'd1		),
	.rst       ( 1'd0		),
	.data      ( uart_out	),
	.dv   	   ( dv			),
	.note_num  ( note_num	),
	.note_note ( note_note	),
	.program   ( program	)
);


nco osc  (
	.clk 	    (clk	    ),
	.ce			(1'd1       ),
	.note_num   (note_num   ),
	.note_note  (note_note  ),
	.program    (program    ),
	.sample_out (sample_out )
);

endmodule