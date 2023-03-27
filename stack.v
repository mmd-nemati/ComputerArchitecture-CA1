`timescale 1ns/1ns

module stack(clk, xIn, rst, yIn, push, pop, xOut, yOut, fail);
        input clk, rst;
        input [3:0] xIn, yIn;
        input push, pop;
        output reg [3:0] xOut, yOut;
        output reg fail;
        reg [7:0] stackMem [0:255];
        reg [5:0] pointer = 6'b0;
        integer i = 0;
        
        always @(posedge clk, posedge rst) begin
                {fail, xOut, yOut} = 9'b0;        
                if (rst) begin
                        for (i = 0; i < 8; i = i + 1)
                                stackMem[i] <= 8'h00;
                end

                else if (push) begin
                        stackMem[pointer] = {xIn, yIn};
                        pointer = pointer + 1;
                end
                
                else if (pop && pointer >= 0) begin
                        {xOut, yOut} = stackMem[pointer];
                        pointer = pointer - 1;
                end
                
                else if (pop && pointer < 0) begin
                        fail = 1'b1;
                end
        end
endmodule