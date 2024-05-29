module seg_8bit (
    input             clk       ,
    input 			  ce        ,
    input 		[7:0] bin_in0    ,
    input 		[7:0] bin_in1    ,
    output reg 	[7:0] seg = 255 ,
    output reg 	[3:0] an
);

wire [2:0] q    ;
wire       ceo  ;

wire [11:0] bcd0;
wire [11:0] bcd1;

wire [3:0] an_out;

wire [7:0] seg0;
wire [7:0] seg1;
wire [7:0] seg2;
wire [7:0] seg3;

assign an_out[0] = ~(q == 2'd0);
assign an_out[1] = ~(q == 2'd1);
assign an_out[2] = ~(q == 2'd2);
assign an_out[3] = ~(q == 2'd3);


always @(posedge clk)
    if(ceo)
        an <= an_out;

always @(posedge clk)
    if(ceo)
        case (q)
            2'd0 : seg <= seg0; 
            2'd1 : seg <= seg1; 
            2'd2 : seg <= {seg2[7:1],1'd0}; 
            2'd3 : seg <= seg3; 
        endcase

bin2bcd conv0 (
    .bin ( bin_in0 ),
    .bcd ( bcd0    )
);

bin2bcd conv1 (
    .bin ( bin_in1 ),
    .bcd ( bcd1    )
);

up_cnt_mod #(
    .MODULO ( 4 ),
    .W      ( 2 )
)
cnt
(
    .clk ( clk   ),
    .ce  ( ceo   ),
    .clr ( 1'd0  ),
    .q   ( q     ),
    .co  (       ) 
);

prescaler #(
    .MODULO ( 500000 ),
    .W      ( 27     )
)
prescaler
(
    .clk ( clk  ),
    .ce  ( 1'd1 ),
    .ceo ( ceo  )
);


bcd7seg bcdseg0 (
    .clk ( clk      ),
    .ce  ( 1'd1     ),
    .bcd ( bcd1[3:0] ),
    .seg ( seg0     )
);

bcd7seg bcdseg1 (
    .clk ( clk      ),
    .ce  ( 1'd1     ),
    .bcd ( bcd1[7:4] ),
    .seg ( seg1     )
);

bcd7seg bcdseg2 (
    .clk ( clk       ),
    .ce  ( 1'd1      ),
    .bcd ( bcd0[3:0] ),
    .seg ( seg2      )
);

bcd7seg bcdseg3 (
    .clk ( clk       ),
    .ce  ( 1'd1      ),
    .bcd ( bcd0[7:4] ),
    .seg ( seg3      )
);

endmodule