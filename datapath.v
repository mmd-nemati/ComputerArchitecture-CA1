`timescale 1ns/1ns

module datapath (clk, rst, rgLd, dir, curLoc, push, pop, cntReach, nxtLoc, empStck, readFromStack);
        input clk, rst, rgLd, push, pop, readFromStack;
        input [1:0] dir;
        output [7:0] curLoc;
// nxtLoc is tmp loc
        output [7:0] nxtLoc;
        output cntReach, empStck;

        wire [3:0] tmpX, tmpY;
        wire sl, co;
        wire [3:0] res, toAdd, addTo;
        wire [3:0] tmp = addTo + dir[0];
        wire [7:0] stackOut;

        /* Hamchenan bayad 00 dar lahze aval dade shavad. Shayad ba rst handle shavad. */

        assign sl = ^dir;// sl==0:y sl==1:x
        assign toAdd = dir[0]? 4'b1: -1;
        assign nxtLoc = readFromStack? stackOut: 
                        sl? {res, curLoc[3:0]}: {curLoc[7:4], res};
        // assign nxtLoc = sl? {res, curLoc[3:0]}: {curLoc[7:4], res};
        assign cntReach = (tmp == 4'b0);
        always @(posedge clk) begin
                $display("curX: ", curLoc[3:0], " currY: ", curLoc[7:4], " rgLd: ", rgLd, " sl: ", sl,
                 " nxtLoc: ", nxtLoc, " res: %b", res, " readFromStack: ", readFromStack, " stackOut: ", stackOut,
                " cntReach: ", cntReach, " tmp: %b", tmp, " tmpX: ", tmpX, " tmpY: ", tmpY, " dir: %b", dir);
        end
        reg4B xLoc(.clk(clk), .rst(rst), .ld(rgLd), .dataIn(tmpX), .dataOut(curLoc[7:4]));
        reg4B yLoc(.clk(clk), .rst(rst), .ld(rgLd), .dataIn(tmpY), .dataOut(curLoc[3:0]));

        reg4B tmpXLoc(.clk(clk), .rst(rst), .ld(sl), .dataIn(res), .dataOut(tmpX));
        reg4B tmpYLoc(.clk(clk), .rst(rst), .ld(~sl), .dataIn(res), .dataOut(tmpY));

        mux2To1 addrMux(.in0(curLoc[3:0]), .in1(curLoc[7:4]), .sl(sl), .out(addTo));
        adder add(.a(addTo), .b(toAdd), .ci(1'b0), .co(co), .sum(res));
        stack stck(.clk(clk), .rst(rst), .locIn(curLoc), .push(push), .pop(pop), .locOut(stackOut), .empStck(empStck));
endmodule