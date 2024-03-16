module wavetable_loader (


);

localparam WTB_ROM_SIZE   = 641;
localparam WTB_ROM_SIZE_W = 10;

localparam WTB_RAM_SIZE   = 61;
localparam WTB_RAM_SIZE_W = 6;

up_cnt_mod_load #(
    .MODULO (WTB_ROM_SIZE   ),
    .W      (WTB_ROM_SIZE_W )
)
wtb_data_addr_cnt
(
    .clk     (      ),
    .ce      (      ),
    .load    (      ),
    .ld_data (      ),   
    .q       (      ), 
    .co      (      )
);

wavetable_offset_rom wtb_offset_inst (
    .clk    (       ),     
    .re     (       ),
    .addr   (       ),
    .data   (       )
);

wavetable_data_rom wtb_data_rom_inst (
    .clk    (       ),
    .re_a   (       ),
    .addr_a (       ),
    .data_a (       ),
    .re_b   (       ),
    .addr_b (       ),
    .data_b (       )
);

sample_rom sample_rom_inst (
    .clk            (       ),
    .re_a           (       ),        
    .addr_a_sample  (       ),
    .addr_a_prog    (       ),
    .data_a         (       ),
    .re_b           (       ),      	  
    .addr_b_sample  (       ),
    .addr_b_prog    (       ),
    .data_b         (       )
);


endmodule