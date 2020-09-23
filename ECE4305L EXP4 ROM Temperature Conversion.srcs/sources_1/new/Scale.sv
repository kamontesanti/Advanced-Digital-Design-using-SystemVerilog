`timescale 1ns / 1ps
// module to define the operations for the scale conversion user select:
module scale
    # (parameter ADDR_WIDTH = 9, DATA_WIDTH = 8)
    (
        // signal declarations:
        input logic clk,                                // synchronicity requires clock
        input logic reset,                              // reset operations
        input logic sw,                                 // switch, 0 for C, 1 for F
        input logic [ADDR_WIDTH - 1:0] value,           // input value specified by the user
        output logic [DATA_WIDTH - 1:0] data            // output data from address value
    );
    
    logic [ADDR_WIDTH - 1:0] addr;                      // determine corresponding address for user input data
    
    // instantiate the synchronous ROM module to communicate with the ROM file:
    synchRom convert(.clk(clk), .addr(addr), .data(data));  // same system clock, address specified, data output

    // combinational circuit to determine the address to be sent (essentially a mux):
    always_comb  
        begin
            // reset address pointer to the first address (for C -> F scale):
            if (reset)
                addr = 101;
            
            // if switch is high, scale: F -> C (requires offset):
            else if (sw)
                begin
                    if ((value > 212) || (value < 0))
                        addr = 101;                         // out of range returns value of 0 C    
                    else    
                        addr = (101 + (value - 32));        // else return appropriate address
                end
            
            // if switch is low, scale: C -> F (no offset required):
            else if (!sw)
                begin
                    if ((value > 100) || (value < 0))
                        addr = 101;                         // out of range returns value of 0 C
                    else
                        addr = value;                       // else return appropriate address
                end
        end
        
endmodule
