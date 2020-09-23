`timescale 1ns / 1ps
// driver module to tie the modules together:
module driver
    # (parameter ADDR_WIDTH = 9, DATA_WIDTH = 8)
    (
        input logic clk, sw, reset,                         // system clock, reset, and switch
        input logic [ADDR_WIDTH - 1:0] value,               // input value for conversion
        output logic [6:0] sseg,                            // output logic for seven segment
        output logic [7:0] AN                               // output logic for selecting the appropriate sseg
    );
    
    //logic [ADDR_WIDTH - 1:0] value;              // input value for conversion
    logic [DATA_WIDTH - 1:0] data;               // output from ROM lookup
    
    // temporary logic for decoded decimal values:
    logic [6:0] valOne, valTen, valHun, dataOne, dataTen, dataHun;
    
    // temporary logic for the driving clock pulses:
    logic segTick;
    
    // logic from modulus up counting:
    logic [2:0] Q;                              // count output for switching across seven-segs
        
    // instantiate the switching scale module for determining the conversion method:
    scale gimmeConv(.clk(clk), .reset(reset), .sw(sw), .value(value), .data(data));
    
    // --------------------------------------------------------------------------------------------------------------
    
    // declare the decoding module interface for output to seven-segment displays (one for input value and one for output):
    segDecoder #(.N(9)) decodeInput(.inVal(value), .outOne(valOne), .outTen(valTen), .outHun(valHun));
    segDecoder #(.N(8)) decodeOutput(.inVal(data), .outOne(dataOne), .outTen(dataTen), .outHun(dataHun));
    
    // instantiate the clock driving the switching of the 7-segment displays (at 400 Hz):
    standardMod #(.M(250_000)) switchClock(.clk(clk), .reset(reset), .Q(), .maxTick(segTick));
    
    // drive this clock output into a binary (modulus) counter for the available seven segments:
    standardMod #(.M(8)) segSwitcher(.clk(segTick), .reset(reset), .Q(Q), .maxTick());
    
    // instantiate the decoding module for shifting on/off seven-segment displays:
    selectSeven displayShift(.sel(Q), .AN(AN));
    
    // instantiate the final multiplexer to output values to the according seven-segments:
    multiplexer outToSeg(.en(Q), .valOne(valOne), .valTen(valTen), .valHun(valHun), .dataOne(dataOne), .dataTen(dataTen), .dataHun(dataHun), .sseg(sseg));
    
endmodule
