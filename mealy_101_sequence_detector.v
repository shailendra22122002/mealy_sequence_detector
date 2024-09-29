module mealy_101_sequence_detector(
    input clk,     // Clock signal
    input reset,   // Reset signal
    input in,      // Input signal (serial input)
    output reg out // Output signal (high when 101 is detected)
);

    // State encoding
    reg [1:0] current_state, next_state;
    
    // Define states
    parameter S0 = 2'b00;  // Initial state
    parameter S1 = 2'b01;  // '1' detected
    parameter S2 = 2'b10;  // '10' detected

    // State transition logic (sequential)
    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= S0; // On reset, go to the initial state
        else
            current_state <= next_state; // Otherwise, transition to next state
    end

    // Next state and output logic (combinational)
    always @(*) begin
        // Default assignments
        next_state = current_state;
        out = 1'b0; // Default output is 0
        
        case (current_state)
            S0: begin
                if (in)
                    next_state = S1; // '1' detected
            end
            S1: begin
                if (!in)
                    next_state = S2; // '10' detected
            end
            S2: begin
                if (in) begin
                    next_state = S1; // '101' detected, go back to detect another '1'
                    out = 1'b1; // Output 1 as '101' is detected
                end else
                    next_state = S0; // Go back to the initial state
            end
        endcase
    end
endmodule
