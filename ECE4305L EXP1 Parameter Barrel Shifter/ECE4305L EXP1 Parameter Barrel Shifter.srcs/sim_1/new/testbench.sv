`timescale 1ns / 1ps

// module for simulation of the 8-bit Barrel Shifter:
module testbench #(parameter N = 3);
    logic [((2**N)-1):0] simA;                  // simulation input (user data)
    logic [(N-1):0] simAmt;                     // simulation amount of shifting
    logic simSel;                               // simulation select operation (0 for left, 1 for right)
    logic [((2**N)-1):0] simOut;                // simulation output value
    
    // instantiate the top driver module:
    barrelDriver uut(.A(simA), .lr(simSel), .amt(simAmt), .Y(simOut));
    
    initial begin
        // testing the left shifting operations:
        # 10
        simSel = 1'b0; simAmt = 3'b010; simA = 8'b00010011; 
        #1
        simAmt = 3'b110;
       
        // testing the right shifting operations:
        # 1
        simSel = 1'b1; simAmt = 3'b010; simA = 8'b00010011;
        #1
        simAmt = 3'b110;
        
        #1 $finish;
    end

endmodule
