`timescale 1ns / 1ps

// module for the decrementation of the temperature values (down counter):
module downCounter
    # (parameter C = 1, N = 9)
    (
        input logic clk, reset,               
        output logic [N - 1:0] value
    );
    
    // declare the state register logic:
    logic [N-1:0] rReg, rNext;
    
    // sequential logic for register transfer:
    always_ff @(posedge clk, posedge reset)
        begin
            if (reset)
                rReg <= 0;
            else
                rReg <= rNext;
        end
    
    // assign the next register value:
    assign rNext = ((value > 212) || (value < 0)) ? 0 : (rReg - C);
    
    // output value is value of current register:
    assign value = rReg;
    
    
endmodule