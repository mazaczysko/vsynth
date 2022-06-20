
module uart_fsm(
    input 			CLK, //Clock
	input 			CLR, //Clear
	input 			CE, //Clock_enable
	input 			DI, //Data_in
	input           HB, //Half_baud
	input           BD, //Baud
	input           LB, //Last_bit
	output  [2:0]  STATUS
    );
    
    //FSM States
    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter START_CHECK = 3'b010;
    parameter READ = 3'b011;
    parameter STOP = 3'b100;
    
    reg [2:0] state = IDLE;
    assign STATUS = state;
    
    always@(posedge CLK)
    begin
        if(CLR)
            state <= IDLE;
        else begin
            if(CE)
            begin
                case(state)
                   IDLE:
                       if(!DI)
                            state <= START;
                       else
                            state <= IDLE;
                    
                    START:
                        if(HB)
                            state <= START_CHECK;
                        else
                            state <= START;
                   
                   START_CHECK:
                        if(DI)
                            state <= IDLE;
                        else
                            state <= READ;
                            
                   READ:
                        if(LB)
                            state <= STOP;
                        else
                            state <= READ;
                            
                   STOP:
                        if(BD)
                            state <= IDLE;
                        else
                            state <= STOP;   
                endcase
            end
        end
    end
    
endmodule