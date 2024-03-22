module debouncer_test
(
  input   clk       ,
  input   rst       ,
  input   sig       ,
  output  reg led = 1'b0
);

wire pedge;
wire nedge;

debouncer_pulse debouncer_inst (
  .clk       (clk   ),
  .rst       (1'b0  ),
  .sig       (sig   ),
  .sig_pedge (pedge ),
  .sig_nedge (nedge ) 
);

always @(posedge clk)
begin
    if (pedge)
        led <= 1'b1;
    else if (nedge)
        led <= 1'b0;
end

endmodule