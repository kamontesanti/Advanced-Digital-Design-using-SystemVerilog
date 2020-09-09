`timescale 1ns / 1ps

// simulation profile for the clock generator:
module testbench();
    localparam N = 4, T = 10;                   // parameters for the generator module
    localparam C = 10;                          // 10 ns clock pulse
    logic [N-1:0] mOn, nOff;                    // parameterized control signals
    logic clock, reset;                         // clock and reset required for synchronicity 
    logic q;                                    // output waveform
    
    // instantiate the unit under test (uut):
    Generator #(.N(N), .T(T)) uut0(.*);         // instantiate the module
    
    // write the logic for the clock generator:
    always
        begin
            clock = 1'b1;
            # (C/2);
            clock = 1'b0;
            # (C/2);
        end
    
    // set the reset high, wait half clock cycle, then set reset low:
    initial
        begin
            reset = 1'b1;
            # (C);
            reset = 1'b0;
        end
        
    initial 
        begin
            // generate a 200 ns clock period:
            mOn = 4'b0001;
            nOff = 4'b0001;  
            
            # (C * 50);
            
            mOn = 4'b0010;
            nOff = 4'b0001;
            
            # (C * 50);
            $stop;  
        end
endmodule
