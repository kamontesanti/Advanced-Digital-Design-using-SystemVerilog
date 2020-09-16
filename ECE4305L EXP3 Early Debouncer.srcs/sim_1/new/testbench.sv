`timescale 1ns / 1ps
// testbench simulation profile for the early debouncer circuit:
// run simulation for around 500 - 1000 ms to see results:
module testbench();

    // signal declarations for simulation:
    localparam T = 10;                      // 10 ns clock pulse
    localparam pulse = 10000000;
    logic sw;
    logic reset;
    logic clock;
    logic dbOut;
    logic [2:1] JA;

    // instantiate unit under test: "driver" module
    driver uut0(.*);

    // generate the clock pulses:
    always
        begin
            clock = 1'b1;
            #(T/2);
            clock = 1'b0;
            #(T/2);
        end
    
    // initialize the system with the reset:
    initial
        begin
            reset = 1'b1;
            #(pulse/2);
            reset = 1'b0;
        end
    

    // generate the switching logic simulation:
    initial
        begin
            // initial value
            //steady pulse
            sw = 1'b0;
            #(pulse)
            sw = 1'b1;
            #(pulse)
            sw = 1'b0;
            #(pulse*6)
    
            // bounced signal (30ms):
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse*6) //stabilized
            sw =1'b0;
            #(pulse/5) //bouncing again
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse*6)
            
            // bounced signal (30ms):
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse*6) //stabilized
            sw =1'b0;
            #(pulse/5) //bouncing again
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
            #(pulse/5)
            sw = 1'b1;
            #(pulse/5)
            sw =1'b0;
        end

endmodule
