`timescale 1ns/1ns

module queue(clk, rst, locIn, enqueue, dequeue, locOut, empQueue);
        input clk, rst, enqueue, dequeue;
        input [7:0] locIn;
        output [7:0] locOut;
        output empQueue;

        reg [5:0] headPointer = 6'b0;
        reg [5:0] tailPointer = 6'b1; // Because we put first data in index 1, instead of index 0. Weird implementation :) 
        assign empQueue = ~(headPointer == 6'b0); 


        reg [7:0] queueMem [0:255];
        reg locOut;
        integer i = 0;
        
        always @(posedge clk, posedge rst) begin
                if (rst) begin
                        for (i = 0; i < 256; i = i + 1)
                                queueMem[i] <= 8'h00;
                        headPointer = 6'b0;
                        tailPointer = 6'b1;
                end

                else if (enqueue) begin
                        headPointer = headPointer + 1;
                        queueMem[headPointer] = locIn;
                end

                else if (dequeue && tailPointer <= headPointer && !empQueue/*Sure? If yes -> also change in stack.v last statement*/) begin 
                        locOut = queueMem[tailPointer];
                        tailPointer = tailPointer + 1;
                end
        end
endmodule