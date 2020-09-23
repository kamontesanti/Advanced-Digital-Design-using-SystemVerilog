`timescale 1ns / 1ps

// system testbench to verify operation of temperature conversion:
module testbench();

    // signal declarations:
    localparam T = 10;                                      // 10 ns clock
    localparam ADDR_WIDTH = 9, DATA_WIDTH = 8;              // parameters for the width of the ROM
    logic clk, sw, reset;                                   // system driver input values
    logic [ADDR_WIDTH - 1:0] value;                         // system driver value to convert
    logic [6:0] sseg;                                       // seven segment coded BCD value
    logic [7:0] AN;                                         // 7-segment switching
    
    // instantiate the unit under test:
    driver #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) uut0(.*);
    
    // generate the clock logic:
    always
        begin
            clk = 1'b1;
            # (T/2);
            clk = 1'b0;
            # (T/2);
        end
    
    // initialize system with reset:
    initial
        begin
            reset = 1'b1;
            # (T);
            reset = 1'b0;
        end
        
    // generate the test vectors:
    initial
        begin
            // perform some C -> F conversions: (sw = 1'b0)
            sw = 1'b0;                                      
            # (T);
            
            // test vectors:
            value = 0;                                      // locate the min. range (F = 32)
            # (T);
            value = 5;                                      // F = 41
            # (T);
            value = 18;                                     // F = 64
            # (T);
            value = 100;                                    // locate the max. range (F = 212)
            # (T);
            
            // perform some F -> C conversions: (sw = 1'b1)
            sw = 1'b1;
            value = 32;                                     // locate the min. range (C = 0)
            # (T);
            value = 41;                                     // C = 5
            # (T);
            value = 64;                                     // C = 18
            # (T);
            value = 212;                                    // locate the max. range (C = 100)
            # (2*T);
            
            
            $stop;
        end
    
endmodule
