module polyphony (
    input clk,
    input ce,
    input rst,
    input [6:0] note_num,
    input [6:0] note_vel,
    input note_on,
    input note_off,
    output [6:0] note_num_0,
    output [6:0] note_num_1,
    output [6:0] note_num_2,
    output [6:0] note_num_3,
    output [6:0] note_vel_0,
    output [6:0] note_vel_1,
    output [6:0] note_vel_2,
    output [6:0] note_vel_3,
    output gate_on_0,
    output gate_on_1,
    output gate_on_2,
    output gate_on_3,
    output gate_off_0,
    output gate_off_1,
    output gate_off_2,
    output gate_off_3
);

reg write_note_0;
reg write_note_1;
reg write_note_2;
reg write_note_3;

reg clr_note_0;
reg clr_note_1;
reg clr_note_2;
reg clr_note_3;

assign gate_on_0 = write_note_0;
assign gate_on_1 = write_note_1;
assign gate_on_2 = write_note_2;
assign gate_on_3 = write_note_3;

assign gate_off_0 = clr_note_0;
assign gate_off_1 = clr_note_1;
assign gate_off_2 = clr_note_2;
assign gate_off_3 = clr_note_3;

always @(posedge clk) 
    if(ce)
        if (note_on)
            if (~|note_vel_0) ///note_vel_0 == 7'd0;
                write_note_0 <= 1'b1;

            else if(~|note_vel_1)
                write_note_1 <= 1'b1;

            else if(~|note_vel_2)
                write_note_2 <= 1'b1;

            else if(~|note_vel_3)
                write_note_3 <= 1'b1;
            
            else begin
                write_note_0 <= 1'b0;
                write_note_1 <= 1'b0;
                write_note_2 <= 1'b0;
                write_note_3 <= 1'b0;
            end
        else begin
            write_note_0 <= 1'b0;
            write_note_1 <= 1'b0;
            write_note_2 <= 1'b0;
            write_note_3 <= 1'b0;
        end		


always @(posedge clk)
    if(ce) begin
        if(note_off)
            if (note_num == note_num_0)
                clr_note_0 <= 1'b1;

            else if (note_num == note_num_1)
                clr_note_1 <= 1'b1;

            else if (note_num == note_num_2)
                clr_note_2 <= 1'b1;

            else if (note_num == note_num_3)
                clr_note_3 <= 1'b1;	

            else begin
                clr_note_0 <= 1'b0;
                clr_note_1 <= 1'b0;
                clr_note_2 <= 1'b0;
                clr_note_3 <= 1'b0;
            end
        else begin
                clr_note_0 <= 1'b0;
                clr_note_1 <= 1'b0;
                clr_note_2 <= 1'b0;
                clr_note_3 <= 1'b0;
        end
    end

//Output registers
//note_num registers
register_clr #(
    .W(7)
)
note_num_0_reg
(
    .clk ( clk          ),
    .ce  ( write_note_0 ),
    .clr ( rst          ),
    .d   ( note_num     ),
    .q   ( note_num_0   )
);

register_clr #(
    .W(7)
)
note_num_1_reg
(
    .clk ( clk          ),
    .ce  ( write_note_1 ),
    .clr ( rst          ),
    .d   ( note_num     ),
    .q   ( note_num_1   )
);

register_clr #(
    .W(7)
)
note_num_2_reg
(
    .clk ( clk          ),
    .ce  ( write_note_2 ),
    .clr ( rst          ),
    .d   ( note_num     ),
    .q   ( note_num_2   )  
);

register_clr #(
    .W(7)
)
note_num_3_reg
(
    .clk ( clk          ),
    .ce  ( write_note_3 ),
    .clr ( rst          ),
    .d   ( note_num     ),
    .q   ( note_num_3   )
);

//note_vel registers
register_clr #(
    .W(7)
)
note_vel_0_reg
(
    .clk ( clk              ),
    .ce  ( write_note_0     ),
    .clr ( rst | clr_note_0 ),
    .d   ( note_vel         ),
    .q   ( note_vel_0       )
);

register_clr #(
    .W(7)
)
note_vel_1_reg
(
    .clk ( clk              ),
    .ce  ( write_note_1     ),
    .clr ( rst | clr_note_1 ),
    .d   ( note_vel         ),
    .q   ( note_vel_1       )
);

register_clr #(
    .W(7)
)
note_vel_2_reg
(
    .clk ( clk              ),
    .ce  ( write_note_2     ),
    .clr ( rst | clr_note_2 ),
    .d   ( note_vel         ),
    .q   ( note_vel_2       )
);

register_clr #(
    .W(7)
)
note_vel_3_reg
(
    .clk ( clk              ),
    .ce  ( write_note_3     ),
    .clr ( rst | clr_note_3 ),
    .d   ( note_vel         ),
    .q   ( note_vel_3       )
);



endmodule