`timescale 1ns / 1ps
// module for the early debouncer FSM module design:
module earlyDebouncer(sw, reset, clock, dbOut);
    input logic sw, reset, clock;                   // driver inputs, switch, reset function, and clock pulse
    output logic dbOut;                             // output of the debouncer module
    
    logic tick;                                     // logic for the tick driver
    
    typedef enum {zero, wait0_1, wait0_2, wait0_3, one, wait1_1, wait1_2, wait1_3} stateType;
    stateType stateReg, stateNext;
    
    // instantiate the modulo-counter module:
    moduloCounter #(.M(1_000_000)) ticker(.clock(clock), .reset(reset), .maxTick(tick));
    
    // register transfer logic at clock pulse and asynchronous reset:
    always_ff @(posedge clock, posedge reset)
        begin
            if (reset)
                stateReg <= zero;
            else
                stateReg <= stateNext;
        end
    
    // combinational logic for the state transitions and output logic:
    always_comb
        begin
            stateNext = stateReg;
            dbOut = 1'b0;
            
            case(stateReg)
                // first state, if switch is high, we branch to next state, "wait1_1":
                zero:
                    begin
                        if (sw)
                            stateNext = wait0_1;
                        else
                            stateNext = zero;
                    end
                
                // this state corresponds to an output of one (early detection): 
                // unconcerned with switch input since we need to now wait for 20 ms:   
                wait0_1:
                    begin
                        dbOut = 1'b1;
                        if (tick)
                            stateNext = wait0_2;
                        else
                            stateNext = wait0_1;
                    end
                
                // this state corresponds to an output of one (early detection): 
                // unconcerned with switch input since we need to now wait for 10 ms:      
                wait0_2:
                    begin
                        dbOut = 1'b1;
                        if (tick)
                            stateNext = wait0_3;
                        else
                            stateNext = wait0_2;
                    end
                    
                // this state corresponds to an output of one (early detection): 
                // unconcerned with switch input since we need to now wait for 10 ms:     
                wait0_3:
                    begin
                        dbOut = 1'b1;
                        if (tick)
                            stateNext = one;
                        else
                            stateNext = wait0_3;
                    end
                
                // if switch is low, transition to next state "wait0_1":   
                one:
                    begin
                        dbOut = 1'b1;
                        if (!sw)
                            stateNext = wait1_1;
                        else
                            stateNext = one;
                    end
                
                // we must continue to wait for 30 ms from this state forward:   
                wait1_1:
                    begin
                        if (tick)
                            stateNext = wait1_2;
                        else
                            stateNext = wait1_1;
                    end
                    
                // we must continue to wait for 20 ms from this state forward:       
                wait1_2:
                    begin
                        if (tick)
                            stateNext = wait1_3;
                        else
                            stateNext = wait1_2;
                    end
                
                // we must continue to wait for 10 ms from this state forward:    
                wait1_3:
                    begin
                        if (tick)
                            stateNext = zero;
                        else
                            stateNext = wait1_3;
                    end
                    
                default: stateNext = zero;
            endcase
        end
    
endmodule
