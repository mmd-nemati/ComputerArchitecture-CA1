`timescale 1ns/1ns

module adder(a, b, ci, co, sum);
        input [3:0] a, b;
        input ci;
        output co;
        output [3:0] sum;

        assign {co, sum} = a + b + ci;
endmodule