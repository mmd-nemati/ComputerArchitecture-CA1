`timescale 1ns/1ns
`define S0 5'd0
`define S1 5'd1
`define S2 5'd2
`define S3 5'd3
`define S4 5'd4
`define S5 5'd5
`define S6 5'd6
`define S7 5'd7
`define S8 5'd8
`define S9 5'd9
`define S10 5'd10
`define S11 5'd11

module controller(clk, rst, start, cntReach, empStck, dIn, run, nxtLoc,
                 wr, rd, fail, done, move, dir, rgLd, pop, currLoc, push, dOut);
        input clk, rst, start, cntReach, empStck , dIn, run;
        input [7:0] nxtLoc;
        
        output [7:0] currLoc;
        output wr, rd, fail, done, move, dir, rgLd, pop, push, dOut;

        reg [1:0] dir = 2'b0;
        reg noDir;
        wire isDestination = &currLoc;

        reg [3:0] ns, ps;
        // reg rgLd, noDir, dir, rd, dOut, done, move, push, currLoc, pop;
        always @(posedge clk, posedge rst) begin
                if (rst)
                        ps <= `S0;
                else if (~rst)
                        ps <= ns;
        end

        always @(ps, start, isDestination, cntReach, noDir, dIn, run) begin
                ns = `S0;
                case (ps)
                        `S0: ns= start? `S1: `S0;
                        `S1: ns= `S2;
                        `S2: ns= isDestination? `S11: `S3;
                        `S3: ns= ~cntReach? `S4: 
                                noDir? `S8: `S3;
                        `S4: ns= `S5;
                        `S5: ns= dIn? `S3: `S6;
                        `S6: ns= `S7;
                        `S7: ns= `S2;
                        `S8: ns= `S9; 
                        `S9: ns= `S10;
                        `S10: ns= `S2;
                        `S11: ns= `S0;
                        default: ns = `S0;
                endcase
        end
        
        reg rgLd, rd, dOut, done, move, push, currLoc, pop;
        always @(ps) begin
                {rgLd, noDir, rd, dOut, done, move, push, pop} = 8'b0;
                case(ps)
                        // `S0: ;
                        // `S1: ;
                        `S2: rgLd = 1'b1;
                        `S3: {noDir, dir} = dir + 1;
                        `S4: rd = 1'b1;
                        `S5: begin
                                dOut = 1'b1; 
                                push = 1'b1; 
                                currLoc = nxtLoc; 
                        end //set currLoc az wall/1 in map//push it into stack//set currLoc = nxtLox 
                        `S6: pop = 1'b1;//pop from stack//set popedLoc az 0 in map//set currLoc as wall/1 in map//set currLoc = popedLoc
                        `S7: done = 1'b1;       //queue
                        `S8: begin 
                                currLoc = 8'b0; 
                                move = 1'b1; 
                        end
                endcase
        end
endmodule