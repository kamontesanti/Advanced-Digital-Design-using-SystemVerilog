`timescale 1ns / 1ps
// module to define the synchronous operation of the defined ROM:
module synchRom 
    # (parameter ADDR_WIDTH = 9, DATA_WIDTH = 8)
    (
        // signal declarations:
        input logic clk,
        input logic [ADDR_WIDTH - 1:0] addr,            // specified address for the ROM memory file
        output logic [DATA_WIDTH - 1:0] data            // corresponding output data for specified address
    );
    
    // force the FPGA to utilize BRAM for the storage of the ROM to preserve logic cell resources:
    (*rom_style = "block"*) logic [DATA_WIDTH - 1:0] rom [0:2 ** ADDR_WIDTH - 1];
    
    // define which file to read from for the ROM virtualization:
    initial
        $readmemh("conversions.mem", rom);              // specified .mem file containing the information
        
    // force the synchronization:
    // for the ROM memory file, first 101 values are C, subsequent are F: (address 101 begins F scale)
    always_ff @(posedge clk)
        begin
            data <= rom[addr];
        end
    
endmodule
