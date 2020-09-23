`timescale 1ns / 1ps
// decoder for the seconds counter:
module segDecoder # (parameter N = 9) (inVal, outOne, outTen, outHun);
    input logic [N - 1:0] inVal;               // input from the input value display (N-bits)
    output logic [6:0] outOne, outTen, outHun; // output value from the decoder
    
    // define integer values for the 
    logic [N - 1:0] val, valTen, valHun, valMod; // integer values as temporary placeholders
    
    always_comb
        begin
            val = inVal;                    // transfer input to temp. integer value
            valHun = (val / 100);           // isolate the hundreds place
            valMod = (val % 10);            // isolate the ones place
            valTen = (val % 100) / 10;      // isolate the tens place
    
            // case select for the one's place:
            case(valMod)
                4'b0000: outOne = 7'b0000001; // output for "0"
                4'b0001: outOne = 7'b1001111; // otuput for "1"
                4'b0010: outOne = 7'b0010010; // output for "2"
                4'b0011: outOne = 7'b0000110; // output for "3"
                4'b0100: outOne = 7'b1001100; // output for "4"
                4'b0101: outOne = 7'b0100100; // output for "5"
                4'b0110: outOne = 7'b0100000; // output for "6"
                4'b0111: outOne = 7'b0001111; // output for "7"
                4'b1000: outOne = 7'b0000000; // output for "8"
                4'b1001: outOne = 7'b0001100; // output for "9"
                default: outOne = 7'b0111000;        
            
            endcase
        
            // case select for the ten's place:
            case(valTen)
                4'b0000: outTen = 7'b0000001; // output for "0"
                4'b0001: outTen = 7'b1001111; // otuput for "1"
                4'b0010: outTen = 7'b0010010; // output for "2"
                4'b0011: outTen = 7'b0000110; // output for "3"
                4'b0100: outTen = 7'b1001100; // output for "4"
                4'b0101: outTen = 7'b0100100; // output for "5"
                4'b0110: outTen = 7'b0100000; // output for "6"
                4'b0111: outTen = 7'b0001111; // output for "7"
                4'b1000: outTen = 7'b0000000; // output for "8"
                4'b1001: outTen = 7'b0001100; // output for "9"
                default: outTen = 7'b0111000;
            endcase
            
            // case select for the hundred's place:
            case(valHun)
                4'b0000: outHun = 7'b0000001; // output for "0"
                4'b0001: outHun = 7'b1001111; // otuput for "1"
                4'b0010: outHun = 7'b0010010; // output for "2"
                4'b0011: outHun = 7'b0000110; // output for "3"
                4'b0100: outHun = 7'b1001100; // output for "4"
                4'b0101: outHun = 7'b0100100; // output for "5"
                4'b0110: outHun = 7'b0100000; // output for "6"
                4'b0111: outHun = 7'b0001111; // output for "7"
                4'b1000: outHun = 7'b0000000; // output for "8"
                4'b1001: outHun = 7'b0001100; // output for "9"
                default: outHun = 7'b0111000;
            endcase
    end  
    
endmodule