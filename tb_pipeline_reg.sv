`timescale 1ns/1ps

module tb_pipeline_reg;

    parameter DATA_WIDTH = 32;
    
    logic                  clk;
    logic                  rst_n;
    logic                  s_valid;
    logic                  s_ready;
    logic [DATA_WIDTH-1:0] s_data;
    logic                  m_valid;
    logic                  m_ready;
    logic [DATA_WIDTH-1:0] m_data;

    pipeline_reg #(.DATA_WIDTH(DATA_WIDTH)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .s_valid(s_valid),
        .s_ready(s_ready),
        .s_data(s_data),
        .m_valid(m_valid),
        .m_ready(m_ready),
        .m_data(m_data)
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
        s_valid = 0;
        s_data  = 0;
        m_ready = 0;
        
        // Reset
        repeat(2) @(posedge clk);
        rst_n = 1;
        
        // Test 1: Normal transfer
        @(posedge clk);
        s_valid = 1;
        s_data  = 8'hAB;
        m_ready = 1;
        @(posedge clk);
        s_valid = 0;
        
        // Test 2: Backpressure
        @(posedge clk);
        s_valid = 1;
        s_data  = 8'hCD;
        m_ready = 0;
        repeat(2) @(posedge clk);
        m_ready = 1;
        @(posedge clk);
        s_valid = 0;
        
        // Test 3: Multiple transfers
        repeat(3) begin
            @(posedge clk);
            s_valid = 1;
            s_data  = $random;
            m_ready = 1;
        end
        @(posedge clk);
        s_valid = 0;
        
        repeat(2) @(posedge clk);
        $display("Simulation complete");
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t | s_valid=%b s_ready=%b s_data=%h | m_valid=%b m_ready=%b m_data=%h",
                  $time, s_valid, s_ready, s_data, m_valid, m_ready, m_data);
    end

endmodule
