
`timescale 1ns/1ns

module reg4bTB();
        reg _clk = 1'b0;
        reg _rst = 1'b0;
        reg _ld;
        reg [3:0] din;
        wire [3:0] dOut;
        reg4B cut1(_clk, _rst, _ld, din, dOut);
        // stack CUT2(.clk(_clk), .xIn(_xIn), .yIn(_yIn), .rst(_rst), .push(_push), .pop(_pop), .xOut(_xOut), .yOut(_yOut), .fail(_fail));

        always #5 _clk <= ~_clk;
        initial begin
                #2;
                _rst = 1'b1;
                #4;
                _rst = 1'b0;
                #9;
                #200 $stop;
                // #10;
                // _ld = 1;
                // din = 4'b0001;
                // #10;
                // _ld = 0;
                // #200 $stop;
        end

endmodule