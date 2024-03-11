module bin2bcd(
    input       [7:0]   bin ,
    output reg  [11:0]  bcd
);
    
reg [3:0] i;   

always @(bin) begin
    bcd = 0; 
    for (i = 0; i < 8; i = i+1) 
        begin
            bcd = {bcd[10:0], bin[7-i]}; //Shifting
            
            if (i < 7) begin
                if (bcd[3:0] > 4'd4) //Adding 3 if 
                    bcd[3:0] = bcd[3:0] + 4'd3;

                if (bcd[7:4] > 4'd4)
                    bcd[7:4] = bcd[7:4] + 4'd3;

                if (bcd[11:8] > 4'd4)
                    bcd[11:8] = bcd[11:8] + 4'd3;  
            end
        end
end     
                
endmodule
