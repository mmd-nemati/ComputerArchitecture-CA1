`timescale 1ns/1ns

module datapath (clk, rst, rgLd, dir, curLoc, push, pop, cntReach, nxtLoc, empStck, readFromStack);
        input clk, rst, rgLd, push, pop, readFromStack;
        input [1:0] dir;
        input [7:0] curLoc;
// nxtLoc is tmp loc
        output [7:0] nxtLoc;
        output cntReach, empStck;

        wire sl, co;
        wire [3:0] res, toAdd, addTo;
        wire [3:0] tmp = addTo + dir[0];
        wire [7:0] stackOut;

        assign sl = ^dir;// sl==0:y sl==1:x
        assign toAdd = dir[0]? 4'b1: -1;
        assign nxtLoc = readFromStack? stackOut: 
                        sl? {res, curLoc[3:0]}: {curLoc[7:4], res};
        // assign nxtLoc = sl? {res, curLoc[3:0]}: {curLoc[7:4], res};
        assign cntReach = (tmp == 4'b0);
        initial begin
                $monitor("x:", curLoc[3:0], " y:", curLoc[7:4], " rgLd:", rgLd, " sl:", sl,
                " nxtLoc:", nxtLoc, " res:", res, " readFromStack:", readFromStack, " stackOut:", stackOut);
        end
        reg4B xLoc(.clk(clk), .rst(rst), .ld(rgLd), .dataIn(curLoc[7:4]), .dataOut(nxtLoc[7:4]));
        reg4B yLoc(.clk(clk), .rst(rst), .ld(rgLd), .dataIn(curLoc[3:0]), .dataOut(nxtLoc[3:0]));
        mux2To1 addrMux(.in0(curLoc[3:0]), .in1(curLoc[7:4]), .sl(sl), .out(addTo));
        adder add(.a(addTo), .b(toAdd), .ci(1'b0), .co(co), .sum(res));
        stack stck(.clk(clk), .rst(rst), .locIn(curLoc), .push(push), .pop(pop), .locOut(stackOut), .empStck(empStck));
endmodule