// module for a 12-to-4 priority encoder that has first and second priorities:
module priEncoder(req, first, second);
    
    // signal declarations:
    input logic [12:1] req;                     // 12-bit input data
    output logic [3:0] first, second;           // first and second priority encoding
    
    logic [3:0] temp;                           // 4-bit temp storage to indicate location of the first priority
    logic [3:0] count;                          // 4-bit count storage to indicate if there are no more 1's in second iteration
    
    // for loop to iterate through the first input and find the most signficant bit that is high:
    always_comb
        begin
            if (req == 0)
                first = 4'b0000;
            else
                begin
                    for (integer i = 1; i < 13; i = i + 1)
                        begin
                        // if the bit is high, assign value of bit to first:     
                            if (req[i])
                                first = i;
                        end
                end
        end
    
    // for loop to iterate through the input and find the second most significant bit that is high:
    always_comb
        begin
        count = 4'b0000;                        // clear the counter value initially
        
            if ((temp == 0) || (temp == 1))
                second = 4'b0000;
            else
                begin
                    for (integer j = 1; j < temp; j = j + 1)
                        begin
                            // if the bit is high, assign value of bit to second:
                            if (req[j])
                                begin
                                    second = j;
                                    count = count + 1;
                                end
                        end
                    
                    // account for there being only one 1 in the input:
                    if (!count)
                        second = 4'b0000;
                end
        end
    
    // assign temporary logic to be the first result:    
    assign temp = first;   
         
endmodule
