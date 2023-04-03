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
`define S12 6'd12
`define S13 6'd13
`define S14 6'd14
`define S15 6'd15

module controller(clk, rst, start, cntReach, empStck, dIn, run, nxtLoc,
                 wr, rd, fail, done, move, dir, rgLd, pop, curLoc, push, dOut, readFromStack);
        input clk, rst, start, cntReach, empStck , dIn, run;
        input [7:0] nxtLoc;
        
        output [7:0] curLoc;
        output wr, rd, fail, done, move, dir, rgLd, pop, push, dOut, readFromStack;

        wire isDestination = &curLoc;

        reg [3:0] ns, ps;
        reg [1:0] dir = 2'b0;
        reg [7:0] curLoc = 8'h00;
        reg noDir, rgLd, rd, dOut, done, move, push, pop, wr, fail, readFromStack;

        always @(posedge clk, posedge rst) begin
                if (rst)
                        ps <= `S0;
                else
                        ps <= ns;
        end

        always @(ps, start, isDestination, cntReach, noDir, dIn, run) begin
                $display("ns: ", ns, " ps: ", ps);
                $display("isDestination: ", isDestination, " cntReach: ", cntReach);
                case (ps)
                        `S0: ns= start? `S1: `S0;
                        `S1: ns= `S2;
                        // `S2: ns= isDestination? `S11: `S3;
                        `S2: ns= `S15;
                        `S15: ns= isDestination? `S11: `S13; /* add a state after toggle up rgLd -> didnt work*/

                        `S13: ns= `S3;
                        `S3: ns= ~cntReach? `S4: 
                                noDir? `S8: `S3;
                        `S4: ns= `S5;
                        `S5: ns= dIn? `S3: `S6;
                        `S6: ns= `S7;
                        `S7: ns= `S2;
                        `S8: ns= empStck? `S12: `S9;
                        `S9: ns= `S14;
                        `S14: ns= `S10;
                        `S10: ns= `S2;
                        `S11: ns= `S0;
                        `S12: ns= `S0;
                        default: ns = `S0;
                endcase
        end

        always @(ps) begin
                {rgLd, noDir, rd, dOut, done, move, push, pop, wr, fail, readFromStack} = 11'b0;
                curLoc = 8'h00;
                $display("inside controller curLoc: ", curLoc);
                case(ps)
                        `S0: curLoc = 8'h00;
                        // `S1: 
                        `S2: rgLd = 1'b1;
                        `S3: {noDir, dir} = dir + 1;
                        `S4: rd = 1'b1;
                        `S6: begin
                                wr = 1'b1;
                                dOut = 1'b1; 
                                push = 1'b1;
                        end 
                        `S7: curLoc = nxtLoc;
                        `S8: begin
                                wr = 1'b1;
                                dOut = 1'b1;
                        end
                        `S9: pop = 1'b1;
                        `S14: readFromStack = 1'b1;
                        `S10: begin
                                wr = 1'b1;
                                dOut = 1'b0;
                        end
                        `S12: fail = 1'b1;
                endcase
        end
endmodule