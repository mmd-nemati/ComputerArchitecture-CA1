`timescale 1ns/1ns

module stackTB();
        reg _clk = 1'b0;
        reg _rst = 1'b0;
        reg _pop = 1'b0;
        reg _push = 1'b0; 
        reg [3:0] _xIn, _yIn;
        wire [3:0] _xOut, _yOut;
        wire _fail = 1'b0;
        stack CUT2(.clk(_clk), .xIn(_xIn), .yIn(_yIn), .rst(_rst), .push(_push), .pop(_pop), .xOut(_xOut), .yOut(_yOut), .fail(_fail));

        always #5 _clk <= ~_clk;
        initial begin
                #10;
                _xIn = 4'h1;
                _yIn = 4'h0;
                #2;
                _push = 1'b1;
                #5;
                _push = 1'b0;
                #16;
                _pop = 1'b1;
                #5;
                _pop = 1'b0;
                #200 $stop;
        end

endmodule