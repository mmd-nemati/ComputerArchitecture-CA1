`timescale 1ns/1ns

module mux2To1(in0, in1, sl, out);
        input [3:0] in0, in1;
        input sl;
        output [3:0] out;

        assign out = (sl == 1'b0) ? in0 : in1; 
endmodule