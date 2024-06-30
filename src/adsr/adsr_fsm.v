module adsr_fsm (
    input clk       ,
    input rst       ,
    
    input gate_on   ,
    input gate_off  ,
    input nco_ov    ,  
    
    output reg [1:0] phase,
    output reg       nco_rst   
);

localparam IDLE          = 3'd0;
localparam START_ATTACK  = 3'd1;
localparam ATTACK        = 3'd2;
localparam START_DECAY   = 3'd3;
localparam DECAY         = 3'd4;
localparam SUSTAIN       = 3'd5;
localparam START_RELEASE = 3'd6;
localparam RELEASE       = 3'd7;

localparam ADSR_A = 2'b00;
localparam ADSR_D = 2'b01;
localparam ADSR_S = 2'b10;
localparam ADSR_R = 2'b11;

reg  [2:0] state;
reg  [2:0] next;


always @(posedge clk)
begin
    if(rst)
        state <= IDLE;
    else
        state <= next;
end

always @(*)
begin
    next = IDLE;
    nco_rst = 1'b1;
    phase = ADSR_A;

    case (state)
        IDLE:
        begin
            nco_rst = 1'b1;
            phase = ADSR_A;
            
            if (gate_on) 
                next = ATTACK;
            else
                next = IDLE;
        end

        START_ATTACK:
        begin
            nco_rst = 1'b1;
            phase = ADSR_A;

            if (gate_off)
                next = IDLE;
            else
                next = ATTACK;
        end

        ATTACK:
        begin
            nco_rst = 1'b0;
            phase = ADSR_A;

            if (gate_on) 
                next = START_ATTACK; 
            else if (gate_off)
                next = START_RELEASE;
            else if (nco_ov)
                next = START_DECAY;
            else
                next = ATTACK;
        end

        START_DECAY:
        begin
            nco_rst = 1'b1;
            phase = ADSR_D;

            if (gate_on)
                next = ATTACK;
            else if (gate_off)
                next = RELEASE;
            else
                next = DECAY;
        end

        DECAY:
        begin
            nco_rst = 1'b0;
            phase = ADSR_D;

            if (gate_on) 
                next = START_ATTACK;
            else if (gate_off)
                next = START_RELEASE;
            else if (nco_ov)
                next = SUSTAIN;
            else
                next = DECAY;
        end

        SUSTAIN:
        begin
            nco_rst = 1'b1;
            phase = ADSR_S;

            if (gate_on)
                next = START_ATTACK;
            else if (gate_off)
                next = START_RELEASE;
            else 
                next = SUSTAIN;
        end

        START_RELEASE:
        begin
            nco_rst = 1'b1;
            phase = ADSR_R;

            if (gate_on)
                next = START_ATTACK;
            else
                next = RELEASE;
        end

        RELEASE:
        begin
            nco_rst = 1'b0;
            phase = ADSR_R;

            if (gate_on)
                next = START_ATTACK;
            else if (nco_ov)
                next = IDLE;
            else
                next = RELEASE;    
        end

        default:
        begin
            next = IDLE;
            phase = 2'd0;
            nco_rst = 1'b1;
        end
            
    endcase
end


endmodule