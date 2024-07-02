module wtb_loader_fsm #(
    parameter WTB_RAM_SIZE = 61
)
(
    input       clk,
    input       rst,
    input       wtb_load,
    input [5:0] wtb_ram_addr_w,
    input [7:0] pure_r_pos_reg_out,
    output reg  fsm_idle,
    output reg  fsm_load_offset,
    output reg  fsm_load_pure_l,
    output reg  fsm_load_pure_r,
    output reg  fsm_fill_factors,
    output reg  fsm_read_wtb_data,
    output reg  fsm_done
);


//FSM States
parameter IDLE  = 3'd0;
parameter LOAD_OFFSET = 3'd1;
parameter READ_WTB_DATA_L = 3'd2;
parameter LOAD_PURE_L = 3'd3; 
parameter READ_WTB_DATA_R = 3'd4;
parameter LOAD_PURE_R = 3'd5;
parameter FILL_FACTORS = 3'd6;
parameter DONE = 3'd7;

reg [2:0] fsm_state;
reg [2:0] fsm_next;


always @(posedge clk)
begin
    if(rst)
        fsm_state <= IDLE;
    else
        fsm_state <= fsm_next;
end

always @(*)
begin
    fsm_idle = 1'b0;
    fsm_load_offset = 1'b0;
    fsm_load_pure_l = 1'b0;
    fsm_load_pure_r = 1'b0;
    fsm_fill_factors = 1'b0;
    fsm_read_wtb_data = 1'b0;
    fsm_done = 1'b0;

    case (fsm_state)
        IDLE: begin
            fsm_idle = 1'b1;
            if (!wtb_load)
                fsm_next = IDLE;
            else
                fsm_next = LOAD_OFFSET;
        end

        LOAD_OFFSET: begin
            fsm_load_offset = 1'b1;
            fsm_next = READ_WTB_DATA_L;
        end

        READ_WTB_DATA_L: begin
            fsm_read_wtb_data = 1'b1;
            fsm_next = LOAD_PURE_L;
        end

        LOAD_PURE_L: begin
            fsm_load_pure_l = 1'b1;
            fsm_next = READ_WTB_DATA_R;
        end

        READ_WTB_DATA_R: begin
            fsm_read_wtb_data = 1'b1;
            fsm_next = LOAD_PURE_R;
        end

        LOAD_PURE_R: begin
            fsm_load_pure_r = 1'b1;
            fsm_next = FILL_FACTORS;
        end

        FILL_FACTORS: begin
            fsm_fill_factors = 1'b1;
            if (wtb_ram_addr_w == WTB_RAM_SIZE-1)
                fsm_next = DONE; 
            else begin
                if (wtb_ram_addr_w == pure_r_pos_reg_out)
                    fsm_next = READ_WTB_DATA_L;
                else
                    fsm_next = FILL_FACTORS;
            end
        end
                  
        DONE: begin
            fsm_done = 1'b1;
            fsm_next = IDLE;
        end

        default: begin
            fsm_idle = 1'b0;
            fsm_load_offset = 1'b0;
            fsm_load_pure_l = 1'b0;
            fsm_load_pure_r = 1'b0;
            fsm_fill_factors = 1'b0;
            fsm_read_wtb_data = 1'b0;
            fsm_done = 1'b0;

            fsm_next = IDLE;
        end

    endcase
end

endmodule