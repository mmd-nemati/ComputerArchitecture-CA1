`timescale 1ns/1ns

module mazeMemoryTB();
        reg _clk = 1'b0;
        reg [3:0] _x, _y;
        reg _dIn, _rd, _wr;
        wire _dOut;
        mazeMemory CUT(.clk(_clk), .x(_x), .y(_y), .dIn(_dIn), .dOut(_dOut), .wr(_wr), .rd(_rd));

        always #5 _clk <= ~_clk;
        initial begin
                #10; 
                _x = 4'b0001;
                _y = 4'b0000;
                _rd = 1'b1;
                #50;
                _x = 4'b0000;
                _y = 4'b0001;
                _rd = 1'b0;
                _wr = 1'b1;
                _dIn = 1'b1;
                #50; 
                _rd = 1'b1;
                _wr = 1'b0;
                #50;
                _rd = 1'b0;
                #200 $stop;
        end
endmodule