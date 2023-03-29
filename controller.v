`timescale 1ns/1ns
`define A 4'd0;
`define B 4'd1;
`define C 4'd2;
`define D 4'd3;
`define E 4'd4;
`define F 4'd5;
`define G 4'd6;
`define H 4'd7;
`define I 4'd8;

module controller(clk, rst, isWall, wrong, emptyStack, xData, yData start, wr, rd, fail, done, move, setWall, dir, run, regLd);
        input clk, rst, isWall, wrong, start;
        inout [3:0] xData, yData; //inOUT
        output reg wr, rd, fail, done, move, setWall, dir, run, regLd;
        reg [2:0] ns, ps;
        wire co = 1'b0;


        always @(ps, start, wrong, isWall) begin
                ns = `A;
                case (ps)
                        `A: ns= start ? `B : `A;
                        `B: ns= `C;
                        `C: ns= (&{xData, yData}) ? `D : `E;
                        `D: ns= `I;
                        `D: ns= (wrong || isWall) ? `D : `E;
                        `E: ns= ((isWall || wrong) && ~co) ? `E :
                                co ? `F: `C;
                        `F: ns= emptyStack ? `H : `C;
                        `G: ns= `A;
                        `H: ns= `A;
                        default: ns= `A;  
                endcase
        end

        always @(posedge clk, posedge rst) begin
                if (rst) begin
                        ps <= `A;
                end
                else
                        ps <= ns;
        end

        always @(ps) begin
                {rd, wr, fail, done, rst, move, setWall, run, regLd} = 6'b0;//////////////////////
                dir = 2'b0;
                case(ps)
                        `A: ;
                        `B: ;
                        `C: regLd = 1'b1, ;//save in register, pop from stack, set wall, remove wall
                        `D: done = 1'b1;
                        `E: {co, dir} = dir + 1;
                        `F: ;
                        `G: move = 1'b1;
                        `H: fail = 1'b1;
                        `I: run = 1'b1;
                endcase 
        end
endmodule