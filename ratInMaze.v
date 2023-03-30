`timescale 1ns/1ns

module ratInMaze(clk, rst, start, run, fail, done, move);
        input clk, rst, start, run;
        output fail, done, move;

        wire [7:0] currLoc = 8'h00;/////
        wire [7:0] nxtLoc;//////////////
        wire [1:0] dir;
        wire pop, push, empStck;
        wire rgLd, cntRch;
        wire rd, wr, wriM, rdfM;

        controller cntrllr(.clk(clk), .rst(rst), .start(start), .cntReach(cntRch), .empStck(empStck), .dIn(rdfM), .run(run), .nxtLoc(),
                         .wr(wr), .rd(rd), .fail(fail) .done(done), .move(move), .dir(dir), .rgLd(rgLd), .pop(pop), .currLoc(), .push(push), .dOut(wriM));
        
        datapath dtpth(.clk(clk), .rst(rst), .rgLd(rgLd), .dir(dir), .currLoc(),
                         .cntReach(cntRch), .nxtLoc());

        stack stck(.clk(clk), .rst(rst), .locIn(), .push(push), .pop(pop),
                         .locOut(), .empStck(empStck));
        
        mazeMemory mzmmr(.clk(clk), .loc(currLoc), .dIn(wriM), .en(), .rd(rd), .wr(wr),
                         .dOut(rdfM));
endmodule