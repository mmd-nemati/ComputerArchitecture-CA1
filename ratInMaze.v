`timescale 1ns/1ns

module ratInMaze(clk, rst, start, run, fail, done, move);
        input clk, rst, start, run;
        output fail, done, move;

        wire [7:0] cLoc, nLoc;
        wire [1:0] dir;
        wire pop, push, empStck;
        wire rgLd, cntRch;
        wire rd, wr, wriM, rdfM, rFStack;

        controller cntrllr(.clk(clk), .rst(rst), .start(start), .cntReach(cntRch), .empStck(empStck), .dIn(rdfM), .run(run), .nxtLoc(nLoc),
                         .wr(wr), .rd(rd), .fail(fail), .done(done), .move(move), .dir(dir), .rgLd(rgLd), .pop(pop), .curLoc(cLoc), .push(push), .dOut(wriM), .readFromStack(rFStack));
        
        datapath dtpth(.clk(clk), .rst(rst), .rgLd(rgLd), .dir(dir), .curLoc(cLoc), .push(push), .pop(pop), .readFromStack(rFStack),
                         .cntReach(cntRch), .nxtLoc(nLoc), .empStck(empStck));

        mazeMemory mzmmr(.clk(clk), .loc(cLoc), .dIn(wriM), .rd(rd), .wr(wr),
                         .dOut(rdfM));
endmodule