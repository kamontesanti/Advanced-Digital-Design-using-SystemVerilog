module Reverse #(parameter N = 3) (inVal, outVal);
    input logic [((2**N)-1):0] inVal;                    // original input data (8-bit)
    output logic [((2**N)-1):0] outVal;                  // output value (8-bit)
    
    // for loop execution to generate the reversal:
    generate 
        genvar i;
            for (i = 0; i < (2**N); i = i + 1)
                assign outVal[i] = inVal[((2**N) - 1) - i];
    endgenerate
    
endmodule
    
