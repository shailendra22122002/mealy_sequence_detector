module tb_mealy_101_sequence_detector();

    reg clk;        // Clock signal
    reg reset;      // Reset signal
    reg in;         // Input signal
    wire out;       // Output signal

    // Instantiate the design under test (DUT)
    mealy_101_sequence_detector DUT (
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );

    // Clock generation (50 MHz, period = 20 ns)
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50% duty cycle, toggles every 10 ns
    end

    // Stimulus generation
    initial begin
        // Initialize inputs
        reset = 1; // Apply reset
        in = 0;
        
        // Wait for a few clock cycles
        #25;
        
        // Release reset and provide test sequence
        reset = 0;
        
        // Apply sequence: 1, 0, 1 (should detect 101)
        in = 1; #20;  // Input '1'
        in = 0; #20;  // Input '0'
        in = 1; #20;  // Input '1', output should go high here (detected 101)
        
        // Continue with more test patterns
        in = 1; #20;  // Input '1', should reset to detect a new sequence
        in = 0; #20;  // Input '0'
        in = 1; #20;  // Input '1', output should go high again

        // Provide some random input
        in = 0; #20;  // Input '0'
        in = 0; #20;  // Input '0'
        in = 1; #20;  // Input '1', output should remain low

        in = 1; #20;  // Input '1'
        in = 0; #20;  // Input '0'
        in = 1; #20;  // Input '1', output should go high again (detected 101)

        // Finish the simulation
        $finish;
    end

    // Monitor the input and output values
    initial begin
        $monitor("At time %0t: in = %b, out = %b", $time, in, out);
    end
endmodule
