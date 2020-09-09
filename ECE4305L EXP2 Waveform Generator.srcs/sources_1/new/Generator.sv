// module for the wave pulse generator:
module Generator #(parameter N = 4, T = 10)(mOn, nOff, clock, reset, q);
    input logic [N-1:0] mOn, nOff;                  // parameterized control signals
    input logic clock, reset;                       // clock and reset required for synchronicity 
    output logic q;                                 // output waveform
    
    // additional logic declarations:
    logic qReg, qNext;                              // state registers for RTL
    logic [N-1:0] count, countNext;                 // counting logic for control of the output wave
    logic [N-1:0] tick, tickNext;                   // tick at each clock pulse for count control
    
    localparam [N-1:0] tickTest = T - 1;            // parameter for the tick testing condition (9)
    
    // onboard clock is 100 MHz, thereby, 10 ns period: count increments every 10 ns, for count of 100, requires 10 cycles:
    
    // sequential descriptions for reset and register-transfer:
    always_ff @(posedge clock)
        begin
            if (reset)
                begin
                    qReg <= 0;                      // reset the contents of the state
                    count <= 0;                     // reset the count logic
                    tick <= 0;
                end
            else
                begin
                    qReg <= qNext;                  // transfer "next" register to current state
                    count <= countNext;             // transfer "next" count value to current count
                    tick <= tickNext;
                end
        end
    
    // combinational logic for the clock pulse generator:    
    always_comb
        begin
            qNext = qReg;                           // transfer the current state to the next state logic
            countNext = count;                      // transfer the current count to the next count logic
            tickNext = tick + 1;
            
            // if the current output is low and the count of the low state has been met, switch output to high:
            if (!qReg && (count == nOff))
                begin
                    qNext = 1'b1;                   // output logic HIGH
                    countNext = 0;                  // reset the counter logic
                end
            
            // if the current output is high and the count of the high state has been met, switch output to low:    
            else if (qReg && (count == mOn))
                begin
                    qNext = 1'b0;                   // output logic LOW
                    countNext = 0;                  // reset the counter logic
                end
            
            else if (tick == tickTest)
                begin
                    countNext = count + 1;          // increment the count every clock cycle
                    tickNext = 4'b0000;             // reset the tick
                end
        end
    
    // assign the output waveform from the register "qReg" to "Q":
    assign q = qReg;                                // continuous assignment for the output waveform
    
endmodule
