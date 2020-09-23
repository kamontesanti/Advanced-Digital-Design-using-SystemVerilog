`timescale 1ns / 1ps
// multiplexer for outputting the BCD data to the 7-segment displays:
module multiplexer 
    (
        input logic [2:0] en,
        input logic [6:0] valOne, valTen, valHun, dataOne, dataTen, dataHun,
        output logic [6:0] sseg
    );
    
    // logic value as a placeholder for zero:
    logic [6:0] zero = 7'b1111111;
    
    // combinational logic for selecting which value is displayed to the 7-segment:
    always_comb
        begin
            case(en)
                3'b000: begin
                            sseg = valOne;
                        end
                3'b001: begin
                            sseg = valTen;
                        end
                3'b010: begin
                            sseg = valHun;
                        end
                3'b011: begin
                            sseg = zero;
                        end
                3'b100: begin
                            sseg = dataOne;
                        end
                3'b101: begin
                            sseg = dataTen;
                        end
                3'b110: begin
                            sseg = dataHun;
                        end
                3'b111: begin
                            sseg = zero;
                        end
                default: sseg = 7'b0000000;
                
            endcase
        end
endmodule