`timescale 1ns/1ns

module datapath(clk, rst, rgLd, dir, currLoc, cntReach, nxtLoc);
        input clk, rst, rgLd;
        input [1:0] dir;
        input [7:0] currLoc;
        output [7:0] nxtLoc;
        output cntReach;

        wire [3:0] currX, currY;
        wire sl;
        wire co;
        wire res;//updated location sum=x-if-sl==1 sum=y-if-sl==0
        wire [3:0] toAdd;
        wire [3:0] addTo;

        wire [3:0] tmp = addTo + dir[0];

        assign {currX, currY} = currLoc;
        assign sl = ^dir;// sl==0:y sl==1:x
        assign toAdd = dir[0]? 4'b1: -1;
        assign nxtLoc = sl? {res, currY}: {currX, res};
        assign cntReach = (tmp == 4'b0);

        reg4b xLoc(.clk(clk), .rst(rst), .ld(rgLd), .data(currX));
        reg4b yLoc(.clk(clk), .rst(rst), .ld(rgLd), .data(currY));
        mux2To1 addrMux(.in0(currY), .in1(currX), .sl(sl), .ou(addTo));
        adder add(.a(addTo), .b(toAdd), .ci(1'b0), .co(co), .sum(res));
endmodule