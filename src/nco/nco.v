module nco (
    input         clk         ,
    input         sample_rate ,
    input  [6:0]  note_num    ,   
    output [6:0]  phase       ,    
    output reg    phase_dv
);

wire [15:0] step_size;
wire [15:0] phase_add_out;
wire [15:0] phase_reg_out;

assign phase  = phase_reg_out[15:9];
assign phase_add_out = phase_reg_out + step_size;

always @(posedge clk)
    phase_dv <= sample_rate;

register #(
    .W(16)
)
phase_reg
(
    .clk ( clk           ),
    .ce  ( sample_rate   ),
    .d   ( phase_add_out ),
    .q   ( phase_reg_out )
);

step_size_rom step_size_rom_inst (
    .clk  ( clk       ),
    .re   ( 1'b1      ),
    .addr ( note_num  ),
    .data ( step_size )
);

endmodule
