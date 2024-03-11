`timescale 1ns / 1ps

module nco_bank_tb;

reg clk, ce;

reg [3:0] sel;

wire [1:0] out;
wire [1:0] rom_out;

initial begin
    clk = 0;
    ce = 0;
    sel = 4'd0;
end

always #1 clk = ~clk;


nco_bank bank(
    .clk        ( clk       ),
    .ce         ( ce        ),
    .rst        ( 1'd0      ),
    .note_num_0 ( 7'd0      ),
    .note_num_1 ( 7'd1      ),
    .note_num_2 ( 7'd2      ),
    .note_num_3 ( 7'd3      ),
    .note_vel_0 ( 7'd127    ),
    .note_vel_1 ( 7'd127    ),
    .note_vel_2 ( 7'd127    ),
    .note_vel_3 ( 7'd127    ),
    .program    ( 7'd0      )
);


initial begin
    
    #5 ce <= 1'd1;

end

endmodule

module rom (
	input clk,
	input ce,
	input [1:0] a,
	output reg [1:0] d
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


   	always @(posedge clk)
    	if (ce)
        	 d <= step_size_rom[a];

endmodule

