`timescale 1ns/1ns
`define S0 5'd0;
`define S1 5'd1;
`define S2 5'd2;
`define S3 5'd3;
`define S4 5'd4;
`define S5 5'd5;
`define S6 5'd6;
`define S7 5'd7;
`define S8 5'd8;
`define S9 5'd9;
`define S10 5'd10;
`define S11 5'd11;

module controller(clk, rst, start, cntReach, empStck, dIn, run, nxtLoc,
                 wr, rd, fail, done, move, dir, rgLd, pop, currLoc, push, dOut);
        input clk, rst, start, cntReach, empStck , dIn, run;
        input [7:0] nxtLoc;
        
        output [7:0] currLoc;
        output wr, rd, fail, done, move, dir, rgLd, pop, push, dOut;

        wire [1:0] dir = 2'b0;
        wire noDir;
        wire isDestination = &currLoc;

        reg [3:0] ns, ps;
        reg rst, rgLd, noDir, done, move, push, pop;

        always @(posedge clk, posedge rst) begin
                if (rst)
                        ps <= `S0;
                else    
                        ps <= ns;
        end

        always @(ps, start, isDestination, cntReach, noDir, dIn, run) begin
                ns = `S0;
                case (ps)
                        `S0: ns= start? `S1: `S0;
                        `S1: ns= `S2;
                        `S2: ns= isDestination? `S7: `S3;
                        `S3: ns= ~cntReach? `S4: 
                                noDir? `S9: `S3;
                        `S4: ns= dIn? `S3: `S5;
                        `S5: ns= `S6;
                        `S6: ns= `S2;
                        `S7: ns= run? `S8: `S7;
                        `S8: ns= `S0;
                        `S9: ns= `S10;
                        `S10: ns= `S11;
                        `S11: ns= `S2;
                        default: ns = `S0;
                endcase
        end
        
        always @(ps) begin
                {rgLd, noDir, done, move, push, pop} = 7'b0;
                dOut = 0;
                case(ps)
                        `S0: ;
                        `S1: ;
                        `S2: rgLd = 1'b1;
                        `S3: {noDir, dir} = dir + 1;//clk!
                        `S4: ;
                        `S5:
                        dOut = 1'b1,            //set currLoc az wall/1 in map.
                        push = 1'b1,            //push it into stack.
                        currLoc = nxtLoc;       //set currLoc = nxtLox
                        `S6:
                        pop = 1'b1;             //pop from stack
                                                //set popedLoc az 0 in map
                                                //set currLoc as wall/1 in map
                                                //set currLoc = popedLoc
                        `S7: done = 1'b1;       //queue
                        `S8: currLoc = 8'b0, move = 1'b1;
                endcase
        end
endmodule