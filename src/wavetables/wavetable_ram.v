module wavetable_ram (
    input            clk              ,
    
    input            re               ,
    input      [5:0] addr_r           ,
    output     [7:0] waveform_left_r  ,
    output     [7:0] waveform_right_r ,
    output     [7:0] factor_r         ,
    output           is_pure_r        ,

    input            we               ,
    input      [5:0] addr_w           ,
    input      [7:0] waveform_left_w  ,
    input      [7:0] waveform_right_w ,
    input      [7:0] factor_w         ,
    input            is_pure_w       
);

localparam RAM_SIZE = 61;

(* ram_style="block" *)
reg  [24:0] wavetable_ram [RAM_SIZE-1:0];

reg  [24:0] data_read;
wire [24:0] data_write;

assign data_write = {is_pure_w, factor_w, waveform_right_w, waveform_left_w};

assign waveform_left_r  = data_read[7:0]    ;
assign waveform_right_r = data_read[15:8]   ;
assign factor_r         = data_read[23:16]  ;
assign is_pure_r        = data_read[24]     ;

always @(posedge clk)
    if (re)
        data_read <= wavetable_ram[addr_r];
    else if (we)
        wavetable_ram[addr_w] <= data_write;   

endmodule
