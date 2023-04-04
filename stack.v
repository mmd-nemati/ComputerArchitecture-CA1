`timescale 1ns/1ns

module stack(clk, rst, locIn, push, pop, locOut, empStck);
        input clk, rst, push, pop;
        input [7:0] locIn;
        output [7:0] locOut; 
        output empStck;

        reg [5:0] pointer = 6'b0;
        assign empStck = (pointer == 6'b0); // This should be under pointer declaration unless it gives some 
                                             // weird compilation error about not declaring and double declaring :/

        reg [7:0] stackMem [0:255];
        reg [7:0] locOut;
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
                $display("pointer: %d, empStack: %b stackX: %d stackY: %d", pointer, empStck, locOut[7:4], locOut[3:0]);
        end
endmodule