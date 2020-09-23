`timescale 1ns / 1ps
// module description of a standard modulo counter logic:
module standardMod #(parameter M = 1_000_000) (clk, reset, Q, maxTick);
    localparam N = $clog2(M);                             // required bit-width for modulation counting
    input logic clk, reset;                               // driving input variables
    output logic maxTick;                                 // output pulse to indicate modulation
    output logic [N-1:0] Q;
    
    // declare the state register logic:
    logic [N-1:0] rReg, rNext;
    
    // sequential separation for register transfer logic:
    always_ff @(posedge clk, posedge reset)
        begin
            if (reset)
                rReg <= 0;
            else
                rReg <= rNext;
        end
    
    // assing the next state logic:
    assign rNext = (rReg == (M - 1)) ? 0 : (rReg + 1);
    
    // assign output logic:
    assign Q = rReg;
  
    // assign output tick for modulation counter:
    assign maxTick = (rReg == (M - 1)) ? 1'b1 : 1'b0;
    
    
endmodule