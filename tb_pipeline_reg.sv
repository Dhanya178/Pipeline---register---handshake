`timescale 1ns/1ps

module tb_pipeline_reg;

    parameter DATA_WIDTH = 32;
    
    logic                  clk;
    logic                  rst_n;
    logic                  in_valid;
    logic                  in_ready;
    logic [DATA_WIDTH-1:0] in_data;
    logic                  out_valid;
    logic                  out_ready;
    logic [DATA_WIDTH-1:0] out_data;

    pipeline_reg #(.DATA_WIDTH(DATA_WIDTH)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .in_data(in_data),
        .out_valid(out_valid),
        .out_ready(out_ready),
        .out_data(out_data)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_pipeline_reg);
    end
    
    initial begin
        // Initialize
        rst_n   = 0;
        in_valid = 0;
        in_data  = 0;
        out_ready = 0;
        
        // Reset
        repeat(2) @(posedge clk);
        rst_n = 1;
        
        // Test 1: Normal transfer
        @(posedge clk);
        in_valid = 1;
        in_data  = 8'hAB;
        out_ready = 1;
        @(posedge clk);
        in_valid = 0;
        
        // Test 2: Backpressure
        @(posedge clk);
        in_valid = 1;
        in_data  = 8'hCD;
        out_ready = 0;
        repeat(2) @(posedge clk);
        out_ready = 1;
        @(posedge clk);
        in_valid = 0;
        
        // Test 3: Multiple transfers
        repeat(3) begin
            @(posedge clk);
            in_valid = 1;
            in_data  = $random;
            out_ready = 1;
        end
        @(posedge clk);
        in_valid = 0;
        
        repeat(2) @(posedge clk);
        $display("Simulation complete");
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t | in_valid=%b in_ready=%b in_data=%h | out_valid=%b out_ready=%b out_data=%h",
                  $time, in_valid, in_ready, in_data, out_valid, out_ready, out_data);
    end

endmodule
