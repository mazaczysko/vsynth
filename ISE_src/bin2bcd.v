module bin2bcd(
    input [7:0] BIN,
    output reg [11:0] BCD
);
    
reg [3:0] i;   

always @(BIN) begin
    BCD = 0; 
    for (i = 0; i < 8; i = i+1) 
        begin
            BCD = {BCD[10:0], BIN[7-i]}; //Shifting
            
            if (i < 7) begin
                if (BCD[3:0] > 4'd4) //Adding 3 if 
                    BCD[3:0] = BCD[3:0] + 4'd3;

                if (BCD[7:4] > 4'd4)
                    BCD[7:4] = BCD[7:4] + 4'd3;

                if (BCD[11:8] > 4'd4)
                    BCD[11:8] = BCD[11:8] + 4'd3;  
            end
        end
end     
                
endmodule
