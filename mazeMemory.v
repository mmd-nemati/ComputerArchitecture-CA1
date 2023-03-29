`timescale 1ns/1ns

module mazeMemory(clk, x, y, en, rd, wr, dIn, dOut);
        input clk, dIn, rd, wr;
        input [3:0] x;
        input [3:0] y;
        output reg dOut;
        reg [0:15] map [0:15];

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