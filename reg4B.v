`timescale 1ns/1ns

module reg4B(clk, rst, ld, data);
        input clk, rst, ld;
        inout [3:0] data; // inOUT

        reg [3:0] savedData;
        always @(posedge clk, posedge rst) begin 
                if (rst) begin 
                        savedData <= 4'h0;
                end

                else if (ld) begin 
                        savedData <= data;
                end
        end

        assign data = savedData;
endmodule