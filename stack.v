`timescale 1ns/1ns
`define STACK 6'b111111
`define QUEUE 6'b000001

module stack(clk, rst, locIn, push, pop, done, locOut, empStck); // Done should be only issued in one clock
        input clk, rst, push, pop, done;
        input [7:0] locIn;
        output [7:0] locOut; 
        output empStck;

        reg [5:0] headPointer = 6'b0;
        reg [5:0] mainPointer = 6'b0;
        reg pPopType = `STACK; 
        assign empStck = (pPopType == `STACK)? (headPointer == 6'b0): (mainPointer == headPointer); // This should be under headPointer declaration unless it gives some 
                                             // weird compilation error about not declaring and double declaring :/

        reg [7:0] stackMem [0:255];
        reg [7:0] locOut;
        integer i = 0;

        always @(posedge clk, posedge rst) begin
                if (done) begin 
                        pPopType = 6'b000001;
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

                        else if (pop && headPointer > 0) begin
                                locOut = stackMem[mainPointer];
                                headPointer = headPointer + pPopType;    
                                mainPointer = headPointer;
                        end
                end
                $display("done: %b, pPopType: %d, push: %b, pop: %b, headPointer: %d, mainPointer: %d, empStack: %b, stackX: %d, stackY: %d, stackMem[mainPointer]: %b",done, pPopType, push, pop, headPointer, mainPointer, empStck, locOut[7:4], locOut[3:0], stackMem[mainPointer]);
        end
endmodule