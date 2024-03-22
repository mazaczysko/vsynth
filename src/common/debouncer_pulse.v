module debouncer_pulse #(
    parameter W = 8,
    parameter PRESCALER_MODULO = 1000000,
    parameter PRESCALER_MODULO_W = 20
)
(
  input   clk       ,
  input   rst       ,
  input   sig       ,
  output  sig_pedge ,
  output  sig_nedge  
);

wire [W-1:0] shift_reg_out;
wire debounced_sig; 
wire pre_ceo;

assign debounced_sig = &shift_reg_out;

edge_detector edge_detector_inst (
    .clk    (clk            ),
    .ce     (pre_ceo        ),
    .sig    (debounced_sig  ),
    .pedge  (sig_pedge      ),
    .nedge  (sig_nedge      )
);

shift_reg_right #(
  .W( W )
)
shift_reg_inst
(
  .clk    (clk            ),
  .clr    (rst            ),
  .ce     (pre_ceo        ),
  .d      (sig            ),
  .q      (shift_reg_out  )
);

prescaler #(
    .MODULO (PRESCALER_MODULO   ),
    .W      (PRESCALER_MODULO_W )
    
)
prescaler_inst
(
    .clk (clk       ),
    .ce  (1'b1      ),
    .ceo (pre_ceo   )
);


endmodule
