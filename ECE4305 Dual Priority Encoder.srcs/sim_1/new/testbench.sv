`timescale 1ns / 1ps
// testbench to confirm/represent the behavior of the daul-priority encoder:
module testbench();
    
    // exact signal declarations:
    logic [12:1] req;                           // 12-bit input data
    logic [3:0] first, second;                  // first and second priority encoding
    
    // synthetic "clock" model (not actually clock):
    localparam T = 10;                          // 10 ns (native pulse)
    
    // instantiate the unit under test (uut):
    priEncoder uut0(.*);                        // send through all signal declarations of same name
    
    // test vector logic:
    initial
        begin
            req = 12'h880;                      // input is 1000 1000 0000 (output should be first = 12, second = 8)
            # (T/2);                            // delay 5 ns
            req = 12'h700;                      // input is 0111 0000 0000 (output should be first = 11, second = 10)
            # (T/2);
            req = 12'h102;                      // input is 0001 0000 0010 (output should be first = 9, second = 2)
            # (T/2);
            req = 12'hFFF;                      // input is 1111 1111 1111 (output should be first = 12, second = 11)
            # (T/2);
            req = 12'h003;                      // input is 0000 0000 0011 (output should be first = 2, second = 1)
            # (T/2);
            req = 12'h505;                      // input is 0101 0000 0101 (output should be first = 11, second = 9)
            # (T/2);
            req = 12'h800;                      // input is 1000 0000 0000 (output should be first = 12, second = 0)
            # (T/2);
            req = 12'h000;                      // input is 0000 0000 0000 (output should be first = 0, second = 0)
            # (T/2);
            $stop;
        end
    
endmodule
