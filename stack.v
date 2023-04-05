`timescale 1ns/1ns
`define STACK 1'b0
`define QUEUE 1'b1

module stack(clk, rst, locIn, push, pop, done, locOut, empStck); // Done should be only issued in one clock
        input clk, rst, push, pop, done;
        input [7:0] locIn;
        output [7:0] locOut; 
        output empStck;

        reg [5:0] headPointer = 6'b0;
        reg [5:0] mainPointer = 6'b0;
        reg pPopType = `STACK; 
        assign empStck = (pPopType == `STACK)? (headPointer == 6'b0): (mainPointer == headPointer);

        reg [7:0] stackMem [0:255];
        reg [7:0] locOut;
        integer i = 0;

        always @(posedge clk, posedge rst) begin
                if (done) begin 
                        pPopType = `QUEUE;
                        mainPointer = 6'b0;
                        $display("Reached here, pPopType: %b %d", pPopType, pPopType);
                end

                else begin 
                        if (rst) begin
                                for (i = 0; i < 256; i = i + 1)
                                        stackMem[i] <= 8'h00;
                                headPointer = 6'b0;
                                mainPointer = 6'b0;
                        end

                        else if (push) begin
                                headPointer = headPointer + 1;
                                mainPointer = headPointer;
                                stackMem[mainPointer] = locIn;
                        end

                        else if (pop && headPointer > 0 && pPopType == `QUEUE) begin
                                locOut = stackMem[mainPointer];
                                // headPointer = headPointer + 1;    
                                mainPointer = mainPointer + 1;
                        end

                        else if (pop && headPointer > 0 && pPopType == `STACK) begin 
                                locOut = stackMem[mainPointer];
                                headPointer = headPointer - 1;    
                                mainPointer = headPointer;
                        end
                end
                $display("done: %b, pPopType: %d, push: %b, pop: %b, headPointer: %d, mainPointer: %d, empStack: %b, stackX: %d, stackY: %d, stackMem[mainPointer]: %b",done, pPopType, push, pop, headPointer, mainPointer, empStck, locOut[7:4], locOut[3:0], stackMem[mainPointer]);
        end
endmodule