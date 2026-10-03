`timescale 1ns / 1ps

module calculator_tb;

    reg        clk;
    reg        rst_n;
    reg        enable;
    reg  [2:0] opcode;
    reg  [7:0] operand_a;
    reg  [7:0] operand_b;
    wire [15:0] result;
    wire        zero;
    wire        overflow;

    // Instantiate Device Under Test (DUT)
    calculator dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .opcode(opcode),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .result(result),
        .zero(zero),
        .overflow(overflow)
    );

    // Clock generator (100 MHz, 10ns period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("calculator.vcd");
        $dumpvars(0, calculator_tb);

        // Initialize signals
        clk       = 0;
        rst_n     = 0;
        enable    = 0;
        opcode    = 3'b000;
        operand_a = 8'd0;
        operand_b = 8'd0;

        // Reset pulse
        #15 rst_n = 1; enable = 1;

        $display("---------------------------------------------------------------");
        $display("  Time | Opcode | Operation |   A   |   B   |   Result  | Z | OV ");
        $display("---------------------------------------------------------------");

        // 1. ADD: 45 + 55 = 100
        @(posedge clk);
        opcode = 3'b000; operand_a = 8'd45; operand_b = 8'd55;
        @(posedge clk); #1;
        $display("%5t  |  %3b   |   ADD     |  %3d  |  %3d  |   %5d   | %b |  %b",
                 $time, opcode, operand_a, operand_b, result, zero, overflow);

        // 2. SUB: 100 - 35 = 65
        @(posedge clk);
        opcode = 3'b001; operand_a = 8'd100; operand_b = 8'd35;
        @(posedge clk); #1;
        $display("%5t  |  %3b   |   SUB     |  %3d  |  %3d  |   %5d   | %b |  %b",
                 $time, opcode, operand_a, operand_b, result, zero, overflow);

        // 3. MULT: 15 * 12 = 180
        @(posedge clk);
        opcode = 3'b010; operand_a = 8'd15; operand_b = 8'd12;
        @(posedge clk); #1;
        $display("%5t  |  %3b   |   MULT    |  %3d  |  %3d  |   %5d   | %b |  %b",
                 $time, opcode, operand_a, operand_b, result, zero, overflow);

        // 4. AND: 8'b11110000 & 8'b10101010 = 8'b10100000 (160)
        @(posedge clk);
        opcode = 3'b011; operand_a = 8'hF0; operand_b = 8'hAA;
        @(posedge clk); #1;
        $display("%5t  |  %3b   |   AND     |  %3d  |  %3d  |   %5d   | %b |  %b",
                 $time, opcode, operand_a, operand_b, result, zero, overflow);

        // 5. XOR: 8'hFF ^ 8'hFF = 0 (checks Zero flag)
        @(posedge clk);
        opcode = 3'b101; operand_a = 8'hFF; operand_b = 8'hFF;
        @(posedge clk); #1;
        $display("%5t  |  %3b   |   XOR     |  %3d  |  %3d  |   %5d   | %b |  %b",
                 $time, opcode, operand_a, operand_b, result, zero, overflow);

        // 6. ADD with overflow: 200 + 100 = 300 (exceeds 8 bits, OV=1)
        @(posedge clk);
        opcode = 3'b000; operand_a = 8'd200; operand_b = 8'd100;
        @(posedge clk); #1;
        $display("%5t  |  %3b   |   ADD(OV) |  %3d  |  %3d  |   %5d   | %b |  %b",
                 $time, opcode, operand_a, operand_b, result, zero, overflow);

        $display("---------------------------------------------------------------");
        #20 $finish;
    end

endmodule
