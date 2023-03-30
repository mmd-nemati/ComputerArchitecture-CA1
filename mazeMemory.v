`timescale 1ns/1ns

module mazeMemory(clk, loc, dIn, en, rd, wr, dOut);
        input clk, dIn, en, rd, wr;
        input [7:0] loc;
        output dOut;

        reg [0:15] map [0:15];
        reg dOut;
        
        always @(posedge clk, posedge en) begin
                $readmemh("map.txt", map);
        end

        always @(posedge clk, posedge rd) begin
                dOut <= 1'b0;

                if (rd) begin 
                        dOut <= map[x][y];
                end

                else if (wr) begin 
                        map[x][y] <= dIn;
                end                
        end
endmodule