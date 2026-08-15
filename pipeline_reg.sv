module pipeline_reg #(
    parameter DATA_WIDTH = 32
)(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  s_valid,
    output logic                  s_ready,
    input  logic [DATA_WIDTH-1:0] s_data,
    output logic                  m_valid,
    input  logic                  m_ready,
    output logic [DATA_WIDTH-1:0] m_data
);

    logic [DATA_WIDTH-1:0] data_reg;
    logic                  valid_reg;

    assign s_ready = !valid_reg || m_ready;
    assign m_valid = valid_reg;
    assign m_data  = data_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_reg <= 1'b0;
            data_reg  <= '0;
        end else begin
            if (s_valid && s_ready) begin
                data_reg  <= s_data;
                valid_reg <= 1'b1;
            end else if (m_valid && m_ready) begin
                valid_reg <= 1'b0;
            end
        end
    end

endmodule
