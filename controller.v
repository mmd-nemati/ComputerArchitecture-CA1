`timescale 1ns/1ns
`define S0 6'd0
`define S1 6'd1
`define S2 6'd2
`define S3 6'd3
`define S4 6'd4
`define S5 6'd5
`define S6 6'd6
`define S7 6'd7
`define S8 6'd8
`define S9 6'd9
`define S10 6'd10
`define S11 6'd11

module controller(clk, rst, start, cntReach, empStck, dIn, run, nxtLoc, curLoc,
                 wr, rd, fail, done, move, dir, rgLd, pop, push, dOut, adderEn, giveTMem);
        input clk, rst, start, cntReach, empStck , dIn, run;
        input [7:0] nxtLoc, curLoc;
        
        output wr, rd, fail, done, move, dir, rgLd, pop, push, dOut, adderEn;
        output reg [7:0] giveTMem;

        wire isDestination = &nxtLoc;

        reg [3:0] ns, ps;
        reg [1:0] dir = 2'b0;
        reg rgLd, wr, dOut, noDir, rd, push, pop, fail, done, adderEn, move;

        always @(posedge clk) begin
                $monitor("C| ps:", ps, " ns", ns, " dIn:", dIn);
        end

        always @(posedge clk, posedge rst) begin
                if (rst)
                        ps <= `S0;
                else
                        ps <= ns;
        end

        always @(ps, start, isDestination, cntReach, noDir, dIn, run) begin
                case (ps)
                        `S0: ns= start? `S1: `S0;
                        `S1: ns= `S2;
                        `S2: ns= isDestination? `S11: `S3;
                        `S3: ns= ~cntReach? (noDir? `S4: `S7): 
                                ~noDir? `S3: `S7;
                        `S4: ns= dIn? `S3: `S6;
                        // `S5: ns= dIn? `S3: `S6;
                        `S6: ns= `S1;
                        `S7: ns= empStck? `S9: `S8;
                        `S8: ns= `S1;
                        `S9: ns= `S10;
                        `S10: ns= `S0;
                        // `S11: ns= 
                        default: ns = `S0;
                endcase
        end

        always @(ps) begin
                {rgLd, wr, dOut, noDir, rd, push, pop, fail, done, adderEn, move} = 11'b0;
                case(ps)
                        `S1: rgLd = 1'b1;
                        `S2: begin
                                giveTMem = curLoc;
                                wr = 1'b1;
                                dOut = 1'b0;
                                dir = 2'b0;
                        end
                        `S3: begin
                                {noDir, dir} = dir + 1;
                                adderEn = 1'b1;
                        end
                        `S4: begin
                                rd = 1'b1;////////////////////////////
                                giveTMem = nxtLoc;////////////////////
                        end
                        // `S5: begin
                        //         rd = 1'b1;////////////////////////////
                        //         giveTMem = nxtLoc;////////////////////
                        // end
                        `S6: begin
                                giveTMem = curLoc;
                                wr = 1'b1;
                                dOut = 1'b1;
                                push = 1'b1;
                        end
                        `S7: begin
                                giveTMem = curLoc;
                                wr = 1'b1;
                                dOut = 1'b1;
                        end
                        `S8: pop = 1'b1;
                        `S9: fail = 1'b1;
                        `S11: done = 1'b1;
                endcase
        end
endmodule