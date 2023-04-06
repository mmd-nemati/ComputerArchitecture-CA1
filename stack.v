`timescale 1ns/1ns
`define STACK 1'b0
`define QUEUE 1'b1

module stack(clk, rst, locIn, push, pop, done, run, locOut, move, empStck);
        input clk, rst, push, pop, done, run;
        input [7:0] locIn;
        output [7:0] locOut;
        output reg [7:0] move; 
        output empStck;

        reg [7:0] headPointer = 8'b0;
        reg [7:0] mainPointer = 8'b0;
        reg pPopType = `STACK; 
        assign empStck = (pPopType == `STACK)? (headPointer == 8'b0): (mainPointer == headPointer);

        reg [7:0] stackMem [0:255];
        reg [7:0] locOut;
        integer i = 0;

        always @(posedge clk, posedge rst) begin
                $display("run: %b, done: %b, pPopType: %d, push: %b, pop: %b, headPointer: %d, mainPointer: %d, stackX: %d, stackY: %d, stackMem[mainPointer]: %b, empStck: %b",run, done, pPopType, push, pop, headPointer, mainPointer, locOut[7:4], locOut[3:0], stackMem[mainPointer], empStck);
                if (done) begin 
                        pPopType = `QUEUE;
                        mainPointer = 8'b0;
                        $display("Reached here, pPopType: %b %d", pPopType, pPopType);
                end

                else begin 
                        if (rst) begin
                                for (i = 0; i < 256; i = i + 1)
                                        stackMem[i] <= 8'h00;
                                headPointer = 8'b0;
                                mainPointer = 8'b0;
                                pPopType = `STACK;
                        end

                        else if (push) begin
                                headPointer = headPointer + 1;
                                mainPointer = headPointer;
                                stackMem[mainPointer] = locIn;
                        end

                        else if (pop && headPointer > 0 && pPopType == `QUEUE && run) begin
                                locOut = stackMem[mainPointer];
                                mainPointer = mainPointer + 1;
                                move = locOut;
                                $display("run: %b, poped: %b", run, locOut);
                        end

                        else if (pop && headPointer > 0 && pPopType == `STACK) begin 
                                locOut = stackMem[mainPointer];
                                headPointer = headPointer - 1;    
                                mainPointer = headPointer;
                        end
                end
        end
endmodule