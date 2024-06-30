module adsr_top (
    input clk,
    input rst,

    input sample_rate,
    input gate_on,
    input gate_off,

    input [6:0] adsr_a,
    input [6:0] adsr_d,
    input [6:0] adsr_s,
    input [6:0] adsr_r,
    
    output reg [6:0] env_out
);

localparam ADSR_A = 2'b00;
localparam ADSR_D = 2'b01;
localparam ADSR_S = 2'b10;
localparam ADSR_R = 2'b11;

wire [1:0] adsr_phase;

wire fsm_nco_rst;
wire nco_rst;
wire nco_ov;

wire [6:0]  sustain_inv;
wire [13:0] decay_mul;
wire [6:0]  decay_env_out;

wire [13:0] release_mul;
wire [6:0]  release_env_out;

wire [6:0] nco_out;
reg  [6:0] env_time;
wire       nco_out_dv;

assign sustain_inv = 7'd127 - adsr_s;
assign decay_mul = nco_out * sustain_inv; 
assign decay_env_out = 7'd127 - decay_mul[13:7];

assign release_mul = nco_out * adsr_s;
assign release_env_out = adsr_s - release_mul[13:7];

assign nco_rst = rst || fsm_nco_rst;

adsr_fsm adsr_fsm_inst (
    .clk ( clk ),
    .rst ( rst ),
    
    .gate_on  ( gate_on  ),
    .gate_off ( gate_off ),
    .nco_ov   ( nco_ov   ),  
    
    .phase    ( adsr_phase  ),
    .nco_rst  ( fsm_nco_rst ) 
);

adsr_nco adsr_nco_inst (
    .clk         ( clk          ),
    .rst         ( nco_rst      ),
    .sample_rate ( sample_rate  ),
    .env_time    ( env_time     ),   
    .env_scale   ( nco_out      ),
    .env_ov      ( nco_ov       ),    
    .env_dv      ( nco_out_dv   )
);


//env_time mux
always @(*)
begin
    case (adsr_phase)
        ADSR_A:
            env_time = adsr_a;
        ADSR_D:
            env_time = adsr_d;
        ADSR_S:
            env_time = 7'd0;
        ADSR_R:
            env_time = adsr_r;
        default:
            env_time = 7'd0;
    endcase
end

//env_scale mux
always @(posedge clk)
begin
    if (sample_rate) begin
    case (adsr_phase)
            ADSR_A:
                env_out <= nco_out;
            ADSR_D:
                env_out <= decay_env_out;
            ADSR_S:
                env_out <= adsr_s;
            ADSR_R:
                env_out <= release_env_out;
            default:
                env_out <= 7'd0;
        endcase
    end
end






endmodule