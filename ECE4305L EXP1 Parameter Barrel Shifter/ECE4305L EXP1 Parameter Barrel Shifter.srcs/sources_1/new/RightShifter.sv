// module (circuit) for the right shift operations:
module RightShifter #(parameter N = 3) (inVal, shVal, outVal);
    input logic [((2**N)-1):0] inVal;           // input value from user
    input logic [(N-1):0] shVal;                // determined shifting amount
    output logic [((2**N)-1):0] outVal;         // output value of operations
    
    
    logic [(2*(2**N))-1:0] temp;                // temp stage for concatenation
    
    assign temp = {inVal, inVal};               // concatenate with input data twice
    
    assign outVal = temp >> shVal;              // right shift by amount and prevent loss of bits
    
endmodule
