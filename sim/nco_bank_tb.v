`timescale 1ns / 1ps

module nco_bank_tb;

reg CLK, CE;

reg [3:0] sel;

wire [1:0] out;
wire [1:0] rom_out;

initial begin
    CLK = 0;
    CE = 0;
    sel = 4'd0;
end

always #1 CLK = ~CLK;


nco_bank bank(
    .CLK(CLK),
    .CE(CE),
    .RST(1'd0),
    .NOTE_NUM_0(7'd0),
    .NOTE_NUM_1(7'd1),
    .NOTE_NUM_2(7'd2),
    .NOTE_NUM_3(7'd3),
    .NOTE_VEL_0(7'd127),
    .NOTE_VEL_1(7'd127),
    .NOTE_VEL_2(7'd127),
    .NOTE_VEL_3(7'd127),
    .PROGRAM(7'd0)
);


initial begin
    
    #5 CE <= 1'd1;

end





endmodule

module rom (
	input CLK,
	input CE,
	input [1:0] A,
	output reg [1:0] D
);

   	reg [1:0] step_size_rom [3:0];
   
   	//initial
	//	$readmemh("step_size_rom.mem", step_size_rom );

	initial begin
		step_size_rom[0] = 2'd0;
		step_size_rom[1] = 2'd1;
		step_size_rom[2] = 2'd2;
		step_size_rom[3] = 2'd3;
	end


   	always @(posedge CLK)
    	if (CE)
        	 D <= step_size_rom[A];

endmodule

