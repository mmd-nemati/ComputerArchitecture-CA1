`timescale 1ns/1ns

module datapath(clk, rst, rgLd, dir, currLoc, cntReach, nxtLoc);
        input clk, rst, rgLd;
        input [1:0] dir;
        input [7:0] currLoc;
        output [7:0] nxtLoc;
        output cntReach;

        wire [3:0] curX, curY;
        wire sl;
        wire co;
        wire [3:0] res;//updated location sum=x-if-sl==1 sum=y-if-sl==0
        wire [3:0] toAdd;
        wire [3:0] addTo;

        wire [3:0] tmp = addTo + dir[0];

        assign {curX, curY} = currLoc;
        assign sl = ^dir;// sl==0:y sl==1:x
        assign toAdd = dir[0]? 4'b1: -1;
        assign nxtLoc = sl? {res, curY}: {curX, res};
        assign cntReach = (tmp == 4'b0);
        initial begin
                $monitor("monitoring", " currLoc:", currLoc, " dir:", dir, " nxtLoc:", nxtLoc, " rgLd:", rgLd);
        end
        reg4B xLoc(.clk(clk), .rst(rst), .ld(rgLd), .data(curX));
        reg4B yLoc(.clk(clk), .rst(rst), .ld(rgLd), .data(curY));
        mux2To1 addrMux(.in0(curY), .in1(curX), .sl(sl), .out(addTo));
        adder add(.a(addTo), .b(toAdd), .ci(1'b0), .co(co), .sum(res));
endmodule