module cc_decoder (
    input clk ,
    input rst ,

    input  [6:0] cc_num   ,
    input  [6:0] cc_val   ,
    input        cc_valid ,

    output       wtb_load ,
    output [6:0] wtb_num  ,
    output [6:0] wfm_num  ,

    output [6:0] adsr_a   ,
    output [6:0] adsr_d   ,
    output [6:0] adsr_s   ,
    output [6:0] adsr_r   
);

localparam CC_WTB_NUM = 7'd110;
localparam CC_WFM_NUM = 7'd111;
localparam CC_WTB_LOAD = 7'd112;

localparam CC_ATTACK = 7'd73; 
localparam CC_DECAY = 7'd75;
localparam CC_SUSTAIN = 7'd64;
localparam CC_RELEASE = 7'd72; 

wire wtb_num_ce;
wire wfm_num_ce;

wire adsr_a_ce;
wire adsr_d_ce;
wire adsr_s_ce;
wire adsr_r_ce;

assign wtb_num_ce = cc_num == CC_WTB_NUM && cc_valid;
assign wfm_num_ce = cc_num == CC_WFM_NUM && cc_valid;
assign wtb_load = cc_num == CC_WTB_LOAD && cc_valid;

assign adsr_a_ce = cc_num == CC_ATTACK && cc_valid;
assign adsr_d_ce = cc_num == CC_DECAY && cc_valid;
assign adsr_s_ce = cc_num == CC_SUSTAIN && cc_valid;
assign adsr_r_ce = cc_num == CC_RELEASE && cc_valid;

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
    

register_clr #(
    .W(7)
)
adsr_attack_reg
(
    .clk ( clk          ),
    .ce  ( adsr_a_ce    ),
    .clr ( rst          ),
    .d   ( cc_val       ),
    .q   ( adsr_a       )
);

register_clr #(
    .W(7)
)
adsr_decay_reg
(
    .clk ( clk			),
    .ce  ( adsr_d_ce    ),
    .clr ( rst          ),
    .d   ( cc_val       ),
    .q   ( adsr_d       )
);

register_set #(
    .W(7)
)
adsr_sustain_reg
(
    .clk ( clk          ),
    .set ( rst          ),
    .ce  ( adsr_s_ce    ),
    .d   ( cc_val       ),
    .q   ( adsr_s       )
);

register_clr #(
    .W(7)
)
adsr_release_reg
(
    .clk ( clk	        ),
    .ce  ( adsr_r_ce    ),
    .clr ( rst          ),
    .d   ( cc_val       ),
    .q   ( adsr_r       )
);
    
    


endmodule

