`timescale 1ns / 1ps

module midi_tb;

reg CLK;
reg CE;
reg DV;
reg RST;
reg [7:0] DATA;
wire [6:0] NOTE_NUM;
wire [6:0] NOTE_VEL;
wire [6:0] PROGRAM;



initial begin
    CLK = 0;
    CE = 1;
	RST = 0;
	DV = 0;
	DATA = 0;
end

always #1 CLK = ~CLK; 

midi midi1(
	.CLK(CLK),
	.CE(CE),
	.RST(RST),
	.data(DATA),
	.dv(DV),
	.NOTE_NUM(NOTE_NUM),
	.NOTE_VEL(NOTE_VEL),
	.PROGRAM(PROGRAM)
);

initial begin
    //NOTE ON
	#20 DATA = 8'h90; //Status note on
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd69; //Note num
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd100; //Note vel
	#2	DV = 1;
	#2 	DV = 0;
	
	#20 DATA = 8'h80; //Status note off
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd70; //Note num -> WRONG
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd50; //Note vel
	#2	DV = 1;
	#2 	DV = 0;

    #20 DATA = 8'h80; //Status note off
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd69; //Note num -> GOOD
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd50; //Note vel
	#2	DV = 1;
	#2 	DV = 0;

    #20 DATA = 8'hc0; //Status program
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd127; //Program
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd50; //Some useless data
	#2	DV = 1;
	#2 	DV = 0;
	
	#20 DATA = 8'hc0; //Status program
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd30; //Program
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd50; //Some useless data
	#2	DV = 1;
	#2 	DV = 0;
	
	#20 DATA = 8'hff; //Status RESET
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd30; //Some data bytes
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd50;
	#2	DV = 1;
	#2 	DV = 0;
	
	//NOTE ON
	#20 DATA = 8'h90; //Status note on
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd69; //Note num
	#2	DV = 1;
	#2 	DV = 0;
	#20	DATA = 8'd100; //Note vel
	#2	DV = 1;
	#2 	DV = 0;



end


endmodule