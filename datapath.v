`timescale 1ns/1ns

module datapath(clk, rst, rgLd, dir, curLoc, cntReach, nxtLoc);
        input clk, rst, rgLd;
        input [1:0] dir;
        input [7:0] curLoc;
        output [7:0] nxtLoc;
        output cntReach;

        wire sl, co;
        wire [3:0] res, toAdd, addTo;
        wire [3:0] tmp = addTo + dir[0];

        assign sl = ^dir;// sl==0:y sl==1:x
        assign toAdd = dir[0]? 4'b1: -1;
        // assign nxtLoc = rgLd? nxtLoc:
        //                         sl? {res, curLoc[3:0]}: {curLoc[7:4], res};
        assign nxtLoc = sl? {res, curLoc[3:0]}: {curLoc[7:4], res};
        assign cntReach = (tmp == 4'b0);
        initial begin
                $monitor("monitoring", " curLoc:", curLoc, " dir:", dir, " nxtLoc:", nxtLoc, " rgLd:", rgLd, " nxtLoc", nxtLoc);
        end
        reg4B xLoc(.clk(clk), .rst(rst), .ld(rgLd), .dataIn(curLoc[7:4]) , .dataOut(nxtLoc[7:4]));
        reg4B yLoc(.clk(clk), .rst(rst), .ld(rgLd), .dataIn(curLoc[3:0]) , .dataOut(nxtLoc[3:0]));
        mux2To1 addrMux(.in0(curLoc[3:0]), .in1(curLoc[7:4]), .sl(sl), .out(addTo));
        adder add(.a(addTo), .b(toAdd), .ci(1'b0), .co(co), .sum(res));
endmodule