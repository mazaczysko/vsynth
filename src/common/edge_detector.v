module edge_detector (
    input       clk     ,
    input       ce      ,
    input       sig     ,
    output reg  pedge   ,
    output reg  nedge
); 

reg sig_reg;

always @(posedge clk)
begin
    if (ce)
    begin
        sig_reg <= sig;
        pedge   <= sig & ~sig_reg;
        nedge   <= ~sig & sig_reg;
    end
end
endmodule
