module mux_4_1_hot1 #( 
    parameter W = 8
)
(
    input               clk  ,
    input               ce   ,
    input       [3:0  ] sel  ,
    input       [W-1:0] in_0 ,
    input       [W-1:0] in_1 ,
    input       [W-1:0] in_2 ,
    input       [W-1:0] in_3 ,
    output reg  [W-1:0] out
);

always @(posedge clk)
    if (ce)
        case (sel) 
            4'b1000:
                out <= in_0;

            4'b0100:
                out <= in_1;

            4'b0010:
                out <= in_2;

            4'b0001:
                out <= in_3;
            
            default:
                out <= out;        
        endcase

endmodule