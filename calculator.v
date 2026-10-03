// 8-bit Arithmetic & Logic Calculator for ASIC implementation
// Supported Operations:
// 3'b000: Addition       (A + B)
// 3'b001: Subtraction    (A - B)
// 3'b010: Multiplication (A * B)
// 3'b011: Bitwise AND    (A & B)
// 3'b100: Bitwise OR     (A | B)
// 3'b101: Bitwise XOR    (A ^ B)
// 3'b110: Shift Left A   (A << 1)
// 3'b111: Shift Right A  (A >> 1)

module calculator (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        enable,
    input  wire [2:0]  opcode,
    input  wire [7:0]  operand_a,
    input  wire [7:0]  operand_b,
    output reg  [15:0] result,
    output reg         zero,
    output reg         overflow
);

    reg [15:0] next_result;
    reg        next_overflow;

    // Combinational ALU logic
    always @(*) begin
        next_overflow = 1'b0;
        case (opcode)
            3'b000: begin // Addition
                next_result = {8'b0, operand_a} + {8'b0, operand_b};
                next_overflow = next_result[8]; // Carry out of 8-bit add
            end
            3'b001: begin // Subtraction
                next_result = {8'b0, operand_a} - {8'b0, operand_b};
                next_overflow = (operand_a < operand_b); // Borrow
            end
            3'b010: begin // Multiplication
                next_result = operand_a * operand_b;
                next_overflow = 1'b0;
            end
            3'b011: begin // Bitwise AND
                next_result = {8'b0, operand_a & operand_b};
            end
            3'b100: begin // Bitwise OR
                next_result = {8'b0, operand_a | operand_b};
            end
            3'b101: begin // Bitwise XOR
                next_result = {8'b0, operand_a ^ operand_b};
            end
            3'b110: begin // Shift Left
                next_result = {7'b0, operand_a, 1'b0};
                next_overflow = operand_a[7]; // Bit shifted out
            end
            3'b111: begin // Shift Right
                next_result = {9'b0, operand_a[7:1]};
                next_overflow = operand_a[0]; // Bit shifted out
            end
            default: begin
                next_result = 16'b0;
                next_overflow = 1'b0;
            end
        endcase
    end

    // Sequential output registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result   <= 16'd0;
            zero     <= 1'b0;
            overflow <= 1'b0;
        end else if (enable) begin
            result   <= next_result;
            zero     <= (next_result == 16'd0);
            overflow <= next_overflow;
        end
    end

endmodule
