// module to define the 2-to-1 multiplexer required:
module mux #(parameter N = 3) (inVal1, inVal2, sel, outVal);
    input logic [((2**N)-1):0] inVal1, inVal2;  // two 8-bit input values (right shift and left shift values)
    input logic sel;                            // single bit operation select (switch)
    output logic [((2**N)-1):0] outVal;         // 8-bit output from desired operation
    
    always_comb
        begin
            outVal = (sel) ? inVal2 : inVal1;   // left shift if high, right shift if low
        end
    
endmodule
