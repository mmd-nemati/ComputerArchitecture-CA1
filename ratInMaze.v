`timescale 1ns/1ns

module ratInMaze(clk, rst, start, run, fail, done, move);
        input clk, rst, start, run;
        output fail, done, move;

        wire [7:0] cLoc, nLoc;
        wire [1:0] dir;
        wire pop, push, empStck, rgLd, cntRch, rd, wr, wriM, rdfM, addEn;

        controller cntrllr(.clk(clk), .rst(rst), .start(start), .cntReach(cntRch), .empStck(empStck), .dIn(rdfM), .run(run), .nxtLoc(nLoc),
                         .wr(wr), .rd(rd), .fail(fail), .done(done), .move(move), .dir(dir), .rgLd(rgLd), .pop(pop), .push(push), .dOut(wriM), .adderEn(addEn));
        
        datapath dtpth(.clk(clk), .rst(rst), .rgLd(rgLd), .dir(dir), .push(push), .pop(pop), .adderEn(addEn),
                         .cntReach(cntRch), .empStck(empStck), .nxtLoc(nLoc), .curLoc(cLoc));

        mazeMemory mzmmr(.clk(clk), .loc(cLoc), .dIn(wriM), .rd(rd), .wr(wr),
                         .dOut(rdfM));
endmodule