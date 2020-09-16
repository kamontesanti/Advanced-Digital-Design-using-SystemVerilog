// module description of a modulo counter logic:
// normally have Q as an output, remove for module:
module moduloCounter #(parameter M = 1_000_000) (clock, reset, maxTick);
    localparam N = $clog2(M);                               // required bit-width for modulation counting
    input logic clock, reset;                               // driving input variables
    output logic maxTick;                                   // output pulse to indicate modulation
    
    // declare the state register logic:
    logic [N-1:0] rReg, rNext;
    
    // sequential separation for register transfer logic:
    always_ff @(posedge clock, posedge reset)
        begin
            if (reset)
                rReg <= 0;
            else
                rReg <= rNext;
        end
    
    // assing the next state logic:
    assign rNext = (rReg == (M - 1)) ? 0 : (rReg + 1);
    
    // assign output tick for modulation counter:
    assign maxTick = (rReg == (M - 1)) ? 1'b1 : 1'b0;
    
    
endmodule
