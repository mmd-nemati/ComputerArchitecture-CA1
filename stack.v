`timescale 1ns/1ns

module stack(clk, rst, locIn, push, pop, locOut, empStck);
        input clk, rst, push, pop;
        input [7:0] locIn;
        output [7:0] locOut; 
        output empStck;

        assign empStck = ~(pointer == 6'b0);

        reg [7:0] stackMem [0:255];
        reg [5:0] pointer = 6'b0;
        reg locOut;
        integer i = 0;

        always @(posedge clk, posedge rst) begin
                if (rst) begin
                        for (i = 0; i < 256; i = i + 1)
                                stackMem[i] <= 8'h00;
                        pointer = 6'b0;
                end

                else if (push) begin
                        pointer = pointer + 1;
                        stackMem[pointer] = locIn;
                end

                else if (pop && pointer > 0) begin
                        locOut = stackMem[pointer];
                        pointer = pointer - 1;    
                end
        end
endmodule