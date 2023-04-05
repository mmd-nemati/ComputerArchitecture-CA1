`timescale 1ns/1ns

module stackTB();
        reg _clk = 1'b0;
        reg _rst = 1'b0;
        reg _pop = 1'b0;
        reg _push = 1'b0;
        reg _done = 1'b0; 
        reg [7:0] _locIn;
        wire [7:0] _locOut;
        wire _empStck;
// module stack(clk, rst, locIn, push, pop, done, locOut, empStck); // Done should be only issued in one clock
        
        stack CUT2(.clk(_clk), .locIn(_locIn), .rst(_rst), .push(_push), .pop(_pop), .done(_done), .locOut(_locOut), .empStck(_empStck));

        always #5 _clk <= ~_clk;
        initial begin
                #10;
                _locIn = 8'h40;
                #2;
                _push = 1'b1;
                #5;
                _push = 1'b0;
                #5;
                _locIn = 8'h01;
                #2;
                _push = 1'b1;
                #6;
                _push = 1'b0;
                _pop = 1'b1;
                #6;
                _pop = 1'b0;
                _locIn = 8'h40;
                #2;
                _push = 1'b1;
                #6;
                _push = 1'b0;
                #6;
                _locIn = 8'ha9;
                #2;
                _push = 1'b1;
                #6;
                _push = 1'b0;
                #25;
                _done = 1'b1;
                #6;
                _done = 1'b0;
                _pop = 1'b1;
                

                #200 $stop;
        end

endmodule