`timescale 1ns / 1ps
// module interfaced with counter to select the 7-segments:
module selectSeven 
    (
        input logic [2:0] sel,              // 4-bit input to the system to determine enables
        output logic [7:0] AN               // output enable signal for the 7-segment displays
    );
    
    // combinational decoding logic for the seven-segment select:
    always_comb
        begin
            AN = 0;                         // initially clear the output values
            
            // decoding logic depends on the input from the binary counter:
            case(sel)
                3'b000: AN = 8'b11111110;      // turn the zeroeth 7-segment display on
                3'b001: AN = 8'b11111101;      // turn the first 7-segment display on
                3'b010: AN = 8'b11111011;      // turn the second 7-segment display on
                3'b011: AN = 8'b11110111;      // turn the third 7-segment display on
                3'b100: AN = 8'b11101111;      // turn the fourth 7-segment display on
                3'b101: AN = 8'b11011111;      // turn the fifth 7-segment display on
                3'b110: AN = 8'b10111111;      // turn the sixth 7-segment display on
                3'b111: AN = 8'b01111111;      // turn the seventh 7-segment display on
                default: AN = 8'b11111111;      // for default, keep 7-segment displays off
            endcase
            
        end
endmodule