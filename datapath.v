`timescale 1ns/1ns

module datapath(clk, rst, dir, xData, yData, wrong);
        input clk, rst;
        inout [3:0] xData, yData; //inOUT
        input [1:0] dir;
        output wrong;

        wire [3:0] tmp = muxOut + dir[0];
        assign wrong = (tmp == 4'b0);
        wire ld, sl, co;
        assign sl = ^dir;
        wire [3:0] sum;
        wire [3:0] muxOut;
        wire [3:0] b;
        assign b = (dir[0] == 1'b0) ? -1 : 4'b1;
        reg4b xLoc(.clk(clk), .rst(rst), .ld(ld), .data(xData));
        reg4b yLoc(.clk(clk), .rst(rst), .ld(ld), .data(yData));
        mux2To1 adderMux(.in0(yData), .in1(xData), .sl(sl), .out(muxOut)); 
        adder add(.a(muxOut), .b(b), .ci(1'b0), .co(co), .sum(sum));
endmodule