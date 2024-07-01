module simple_mul #(
    parameter WIDTH_A = 8,
    parameter WIDTH_B = 8,
    parameter LATENCY = 2
)
(
    input                        clk,
    input                        rst,
    input                        ce,
    input  [WIDTH_A-1:0]         a,
    input  [WIDTH_B-1:0]         b,
    output [WIDTH_A+WIDTH_B-1:0] res,
    output                       res_dv
);

wire res_dv_delay;

assign res_dv = res_dv_delay && ~rst;

MULT_MACRO #(
    .DEVICE  ("7SERIES"), // Target Device: "7SERIES" 
    .LATENCY ( LATENCY ), // Desired clock cycle latency, 0-4
    .WIDTH_A ( WIDTH_A ), // Multiplier A-input bus width, 1-25
    .WIDTH_B ( WIDTH_B )  // Multiplier B-input bus width, 1-18
) 
MULT_MACRO_inst (
    .P   ( res ),     
    .A   ( a   ),     // Multiplier input A bus, width determined by WIDTH_A parameter
    .B   ( b   ),     // Multiplier input B bus, width determined by WIDTH_B parameter
    .CE  ( ce  ),     // 1-bit active high input clock enable
    .CLK ( clk ),     // 1-bit positive edge clock input
    .RST ( rst )      // 1-bit input active high reset
);


generate
    if (LATENCY == 0) begin
        assign res_dv_delay = ce;
    end
    else if(LATENCY == 1) begin
        reg d_ff;
        assign res_dv_delay = d_ff;
        always @(posedge clk)
            d_ff <= ce;
    end
    else
    begin
        shift_reg_right #(
            .W(LATENCY)
        )
        res_dv_delay_reg
        (
            .clk ( clk          ),
            .clr ( rst          ),
            .ce  ( 1'b1         ),
            .d   ( ce           ),
            .q   ( res_dv_delay )
        );
    end
endgenerate

endmodule