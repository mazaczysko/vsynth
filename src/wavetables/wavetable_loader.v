module wavetable_loader (
    input         clk               ,

    input   [4:0] wtb_num           ,
    input         wtb_load          ,
    input   [1:0] voice_num         ,

    output  [3:0] wtb_ram_we        ,
    output  [5:0] wtb_ram_addr_w    ,
    output  [7:0] wtb_ram_wfm_l_w   ,
    output  [7:0] wtb_ram_wfm_r_w   ,
    output  [7:0] wtb_ram_factor_w  ,

    output  [4:0] done_wtb_num      ,
    output        done              ,     
    output        idle              
);

localparam WTB_ROM_SIZE   = 641;
localparam WTB_ROM_SIZE_W = 10;

localparam WTB_RAM_SIZE   = 61;
localparam WTB_RAM_SIZE_W = 6;

//FSM States
parameter IDLE  = 3'd0;
parameter LOAD_OFFSET = 3'd1;
parameter READ_WTB_DATA_L = 3'd2;
parameter LOAD_PURE_L = 3'd3; 
parameter READ_WTB_DATA_R = 3'd4;
parameter LOAD_PURE_R = 3'd5;
parameter FILL_FACTORS = 3'd6;
parameter DONE = 3'd7;

reg [2:0] fsm_state = IDLE;

wire fsm_idle;
wire fsm_idle_and_wtb_load;
wire fsm_load_offset;
wire fsm_load_pure_l;
wire fsm_load_pure_r;
wire fsm_fill_factors;
wire fsm_read_wtb_data;
wire fsm_done;

wire                      wtb_data_addr_cnt_ce;
wire [WTB_ROM_SIZE_W-1:0] wtb_data_addr_cnt_out;
wire                      wtb_data_addr_cnt_co;
wire [WTB_ROM_SIZE_W-1:0] wtb_data_addr_wfm;
wire [WTB_ROM_SIZE_W-1:0] wtb_data_addr_pos;
wire                [7:0] wtb_data_wfm;
wire                [7:0] wtb_data_pos;

wire                      wtb_ram_addr_cnt_ce;
wire                      wtb_ram_addr_cnt_load;
wire [WTB_RAM_SIZE_W-1:0] wtb_ram_addr_cnt_ld_data;
wire [WTB_RAM_SIZE_W-1:0] wtb_ram_addr_cnt_out;
wire                      wtb_ram_addr_cnt_co;

wire wtb_ram_write_enable;

wire [9:0] wtb_offset_rom_out; 
wire [9:0] wtb_offset;

wire [4:0] wtb_num_reg_out;
wire [1:0] voice_num_reg_out;

wire [7:0] pure_l_wfm_reg_out;
wire [7:0] pure_l_pos_reg_out;
wire [7:0] pure_r_wfm_reg_out;
wire [7:0] pure_r_pos_reg_out;

wire  [7:0] distance_btwn_pure_waves;
wire  [7:0] distance_to_left_pure;
wire [15:0] distance_normalized;
wire [15:0] factor_16bit;
wire  [7:0] factor;

assign fsm_idle = fsm_state == IDLE;
assign fsm_idle_and_wtb_load = fsm_state == IDLE & wtb_load;
assign fsm_load_offset = fsm_state == LOAD_OFFSET;
assign fsm_load_pure_l = fsm_state == LOAD_PURE_L;
assign fsm_load_pure_r = fsm_state == LOAD_PURE_R;
assign fsm_fill_factors = fsm_state == FILL_FACTORS;
assign fsm_read_wtb_data = fsm_state == READ_WTB_DATA_L | fsm_state == READ_WTB_DATA_R;
assign fsm_done = fsm_state == DONE;

//Skip first byte of wtb_data (wavetable number)
assign wtb_offset = wtb_offset_rom_out + 8'b1;

assign wtb_data_addr_wfm = wtb_data_addr_cnt_out;
assign wtb_data_addr_pos = wtb_data_addr_cnt_out + 1'b1;

assign wtb_data_addr_cnt_ce = fsm_state == READ_WTB_DATA_L | fsm_state == LOAD_PURE_L | READ_WTB_DATA_R;
assign wtb_ram_addr_cnt_ce = fsm_state == FILL_FACTORS;

assign wtb_ram_addr_cnt_ld_data = fsm_idle_and_wtb_load ? {WTB_RAM_SIZE_W{1'd0}} : wtb_data_pos;
assign wtb_ram_addr_cnt_load = fsm_idle_and_wtb_load | fsm_load_pure_l;

assign distance_btwn_pure_waves = pure_r_pos_reg_out - pure_l_pos_reg_out;
assign distance_to_left_pure = wtb_ram_addr_w - pure_l_pos_reg_out;
assign distance_normalized = 16'hffff / distance_btwn_pure_waves;
assign factor_16bit = distance_normalized * distance_to_left_pure;
assign factor = factor_16bit[15:8];

assign wtb_ram_write_enable = fsm_state == FILL_FACTORS;

//Output definitions
assign wtb_ram_addr_w  = wtb_ram_addr_cnt_out;
assign wtb_ram_wfm_l_w = (wtb_ram_addr_w == pure_r_pos_reg_out ? pure_r_wfm_reg_out : pure_l_wfm_reg_out); 
assign wtb_ram_wfm_r_w = (wtb_ram_addr_w == pure_l_pos_reg_out ? pure_l_wfm_reg_out : pure_r_wfm_reg_out);
assign wtb_ram_factor_w = fsm_fill_factors ? (wtb_ram_wfm_l_w == wtb_ram_wfm_r_w ? 8'h00 : factor) : 8'h00;
assign wtb_ram_we = voice_num_reg_out[1] ? (voice_num_reg_out[0] ? {wtb_ram_write_enable, 3'b000} : {1'b0, wtb_ram_write_enable, 2'b00}) 
                                         : (voice_num_reg_out[0] ? {2'b00, wtb_ram_write_enable, 1'b0} : {3'b000, wtb_ram_write_enable});  

assign done_wtb_num = wtb_num_reg_out;
assign done = fsm_done;
assign idle = fsm_idle;

register #(
    .W(5)
)
wtb_num_reg 
(
    .clk ( clk				        ),
    .ce  ( fsm_idle_and_wtb_load    ),
    .d   ( wtb_num  	            ),
    .q   ( wtb_num_reg_out 	        )
);

register #(
    .W(2)
)
voice_num_reg
(
    .clk ( clk				        ),
    .ce  ( fsm_idle_and_wtb_load    ),
    .d   ( voice_num                ),
    .q   ( voice_num_reg_out        )
);

register_clr #(
    .W(8)
)
pure_left_pos_reg
(
    .clk ( clk	                ),
    .ce  ( fsm_load_pure_l      ),
    .clr ( fsm_idle             ),
    .d   ( wtb_data_pos         ),
    .q   ( pure_l_pos_reg_out   )
);

register_clr #(
    .W(8)
)
pure_left_wfm_reg
(
    .clk ( clk	                ),
    .ce  ( fsm_load_pure_l      ),
    .clr ( fsm_idle             ),
    .d   ( wtb_data_wfm  	    ),
    .q   ( pure_l_wfm_reg_out 	)
);

register_clr #(
    .W(8)
)
pure_right_pos_reg
(
    .clk ( clk                  ),
    .ce  ( fsm_load_pure_r      ),
    .clr ( fsm_idle             ),
    .d   ( wtb_data_pos         ),
    .q   ( pure_r_pos_reg_out 	)
);

register_clr #(
    .W(8)
)
pure_right_wfm_reg
(
    .clk ( clk                  ),
    .ce  ( fsm_load_pure_r      ),
    .clr ( fsm_idle             ),
    .d   ( wtb_data_wfm         ),
    .q   ( pure_r_wfm_reg_out 	)
);

up_cnt_mod_load #(
    .MODULO (WTB_ROM_SIZE-1 ), // wtb_data_addr_pos = wtb_data_addr_cnt_out + 1'b1
    .W      (WTB_ROM_SIZE_W )
)
wtb_data_addr_cnt
(
    .clk     ( clk                      ),
    .ce      ( wtb_data_addr_cnt_ce     ),
    .load    ( fsm_load_offset          ),
    .ld_data ( wtb_offset               ),   
    .q       ( wtb_data_addr_cnt_out    ), 
    .co      ( wtb_data_addr_cnt_co     )
);

up_cnt_mod_load #(
    .MODULO (WTB_RAM_SIZE   ),
    .W      (WTB_RAM_SIZE_W )
)
wtb_ram_addr_cnt
(
    .clk     ( clk                      ),
    .ce      ( wtb_ram_addr_cnt_ce      ),
    .load    ( wtb_ram_addr_cnt_load    ),
    .ld_data ( wtb_ram_addr_cnt_ld_data ),
    .q       ( wtb_ram_addr_cnt_out     ), 
    .co      ( wtb_ram_addr_cnt_co      )
);

wavetable_offset_rom wtb_offset_inst 
(
    .clk    ( clk                   ),     
    .re     ( fsm_idle_and_wtb_load ),
    .addr   ( wtb_num               ),
    .data   ( wtb_offset_rom_out    )
);

wavetable_data_rom wtb_data_rom_inst 
(
    .clk    ( clk                   ),
    .re_a   ( fsm_read_wtb_data     ),
    .addr_a ( wtb_data_addr_wfm     ),
    .data_a ( wtb_data_wfm          ),
    .re_b   ( fsm_read_wtb_data     ),
    .addr_b ( wtb_data_addr_pos     ),
    .data_b ( wtb_data_pos          )
);


//WAVETABLE LOADER FSM
always @(posedge clk)
begin
    case (fsm_state)
        IDLE:
            if (!wtb_load)
                fsm_state <= IDLE;
            else
                fsm_state <= LOAD_OFFSET;

        LOAD_OFFSET:
            fsm_state <= READ_WTB_DATA_L;
        
        READ_WTB_DATA_L:
            fsm_state <= LOAD_PURE_L;

        LOAD_PURE_L:
            fsm_state <= READ_WTB_DATA_R;
        
        READ_WTB_DATA_R:
            fsm_state <= LOAD_PURE_R;

        LOAD_PURE_R:
            fsm_state <= FILL_FACTORS;

        FILL_FACTORS:
            if (wtb_ram_addr_w == WTB_RAM_SIZE-1)
                fsm_state <= DONE; 
            else begin
                if (wtb_ram_addr_w == pure_r_pos_reg_out)
                    fsm_state <= READ_WTB_DATA_L;
                else
                    fsm_state <= FILL_FACTORS;
            end
                  
        DONE:
            fsm_state <= IDLE;

        default:
            fsm_state <= IDLE;

    endcase
end


endmodule