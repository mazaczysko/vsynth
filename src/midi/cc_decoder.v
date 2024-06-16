module cc_decoder (
    input clk ,
    input rst ,

    input  [6:0] cc_num   ,
    input  [6:0] cc_val   ,
    input        cc_valid ,

    output       wtb_load ,
    output [6:0] wtb_num  ,
    output [6:0] wfm_num
);

localparam CC_WTB_NUM = 7'd110;
localparam CC_WFM_NUM = 7'd111;
localparam CC_WTB_LOAD = 7'd112;

wire wtb_num_ce;
wire wfm_num_ce;

assign wtb_num_ce = cc_num == CC_WTB_NUM && cc_valid;
assign wfm_num_ce = cc_num == CC_WFM_NUM && cc_valid;
assign wtb_load = cc_num == CC_WTB_LOAD && cc_valid;

register_clr #(
    .W(7)
)
wtb_num_reg
(
    .clk ( clk          ),
    .ce  ( wtb_num_ce   ),
    .clr ( rst          ),
    .d   ( cc_val       ),
    .q   ( wtb_num      )
);

register_clr #(
    .W(7)
)
wfm_num_reg
(
    .clk ( clk			),
    .ce  ( wfm_num_ce   ),
    .clr ( rst          ),
    .d   ( cc_val       ),
    .q   ( wfm_num      )
);
    



endmodule

