// driver module for the parameterized barrel shifter:
module barrelDriver #(parameter N = 3) (A, lr, amt, Y);
    input logic [((2**N)-1):0] A;               // input entry data (2^N bit width)
    input logic [(N-1):0] amt;                  // specified shifting amount
    input logic lr;                             // shifiting direction select (0 for left, 1 for right)
    output logic [((2**N)-1):0] Y;              // final output of operation and select (2^N bit width)
    
    logic [((2**N)-1):0] temp1, temp2, temp3, temp4; // temporary logic to hold output of operations (2^N bit width)
    
    // module instantiations:
    RightShifter shiftRight(.inVal(A), .shVal(amt), .outVal(temp1)); // instantiate the right shifting module
    Reverse preRev(.inVal(A), .outVal(temp2));                       // pre-reverse the input to prep for left shift
    RightShifter leftShift(.inVal(temp2), .shVal(amt), .outVal(temp3)); // perform the right shifting operations on the reversed value
    Reverse postRev(.inVal(temp3), .outVal(temp4));                  // post-reverse to achieve the right shift
    mux opSel(.inVal1(temp1), .inVal2(temp4), .sel(lr), .outVal(Y)); // instantiate the multiplexer
    
endmodule
