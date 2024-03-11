module uart_fsm(
    input         clk    , //Clock
    input         clr    , //Clear
    input         ce     , //Clock_enable
    input         di     , //Data_in
    input         hb     , //Half_baud
    input         bd     , //Baud
    input         lb     , //Last_bit
    output  [2:0] status
);

//FSM States
parameter IDLE  = 3'b000;
parameter START = 3'b001;
parameter START_CHECK = 3'b010;
parameter READ = 3'b011;
parameter STOP = 3'b100;

reg [2:0] state = IDLE;

assign status = state;

always@(posedge clk)
begin
    if(clr)
        state <= IDLE;
    else begin
        if(ce)
        begin
            case(state)
                IDLE:
                    if(!di)
                        state <= START;
                    else
                        state <= IDLE;
                
                START:
                    if(hb)
                        state <= START_CHECK;
                    else
                        state <= START;
                
                START_CHECK:
                    if(di)
                        state <= IDLE;
                    else
                        state <= READ;
                        
                READ:
                    if(lb)
                        state <= STOP;
                    else
                        state <= READ;
                        
                STOP:
                    if(bd)
                        state <= IDLE;
                    else
                        state <= STOP;   
            endcase
        end
    end
end

endmodule