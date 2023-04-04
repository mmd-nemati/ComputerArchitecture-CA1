`timescale 1ns/1ns

module datapath (clk, rst, rgLd, dir, push, pop, adderEn,
                 cntReach, empStck, nxtLoc, curLoc);
        input clk, rst, rgLd, push, pop, adderEn;
        input [1:0] dir;
        output [7:0] nxtLoc, curLoc;
        output cntReach, empStck;

        wire sl, co;
        wire [3:0] res, toAdd, addTo, tmp;
        wire [7:0] popedLoc;

        assign tmp = addTo + dir[0];
        assign sl = ^dir;
        assign toAdd = dir[0]? 4'b1: -1;
        assign cntReach = (tmp == 4'b0);
        assign addTo = sl? curLoc[7:4]: curLoc[3:0];
        assign nxtLoc = rst? 8'h00:
                        pop? popedLoc:
                        (adderEn && sl)? {res, curLoc[3:0]}:
                        (adderEn && ~sl)? {curLoc[7:4], res}: nxtLoc;

        reg4B xLoc(.clk(clk), .rst(rst), .ld(rgLd), .dataIn(nxtLoc[7:4]), .dataOut(curLoc[7:4]));
        reg4B yLoc(.clk(clk), .rst(rst), .ld(rgLd), .dataIn(nxtLoc[3:0]), .dataOut(curLoc[3:0]));

        adder add(.a(addTo), .b(toAdd), .ci(1'b0), .en(adderEn), .co(co), .sum(res));
        stack stck(.clk(clk), .rst(rst), .locIn(curLoc), .push(push), .pop(pop), .locOut(popedLoc), .empStck(empStck));

        always @(posedge clk) begin
                $display("D| CURx:%d NXTx:%d NXTy:%d dir:%b", curLoc[7:4], nxtLoc[7:4], nxtLoc[3:0], dir);
        end
endmodule