// driver module for the operations:
module driver(sw, reset, clock, dbOut, JA);
    input logic sw, reset, clock;
    output logic dbOut;
    output logic [2:1] JA;                      // delineate the switch value to send to oscilloscope
    
    // instantiate the debouncer module:
    earlyDebouncer debounceMe(.sw(sw), .reset(reset), .clock(clock), .dbOut(dbOut));
    
    // output assignments for the oscilloscope:
    assign JA[1] = sw;
    assign JA[2] = dbOut;
    
endmodule
