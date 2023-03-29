`timescale 1ns/1ns

module datapath(clk, rst, ld, dir, xData, yData, wrong, sum);//new state.
        input clk, rst, ld;
        inout [3:0] xData, yData; //inOUT
        input [1:0] dir;
        output wrong;
        output [3:0] sum;// updated location sum=x-if-sl==1 sum=y-if-sl==0
        assign {xData, yData} = (sl) ? {sum, yData} : {xData, sum};
        wire sl, co;
        wire [3:0] b;

        wire [3:0] tmp = muxOut + dir[0];
        assign wrong = (tmp == 4'b0);
        assign sl = ^dir;// sl==0:y sl==1:x
        wire [3:0] muxOut;
        assign b = (dir[0] == 1'b0) ? -1 : 4'b1;
        reg4b xLoc(.clk(clk), .rst(rst), .ld(ld), .data(xData));
        reg4b yLoc(.clk(clk), .rst(rst), .ld(ld), .data(yData));
        mux2To1 adderMux(.in0(yData), .in1(xData), .sl(sl), .out(muxOut)); 
        adder add(.a(muxOut), .b(b), .ci(1'b0), .co(co), .sum(sum));
endmodule