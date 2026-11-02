`timescale 1ns/1ps

// =========================================================
// 1. SVA VERIFICATION MODULE
// =========================================================
module fsm_1001_sva (
    input logic clk,
    input logic rst,
    input logic d_in,
    input logic detected,
    input logic [1:0] ps
);

    // Invariant: Legal states only
    assert property (@(posedge clk) disable iff (rst)
        ps inside {2'b00, 2'b01, 2'b10, 2'b11})
        else $error("Illegal state reached!");

    // Safety: detected only in s3
    assert property (@(posedge clk) disable iff (rst)
        detected |-> ps == 2'b11)
        else $error("detected went high in wrong state!");

    // Core Mealy check: s3 + d_in=1 -> detected NOW
    assert property (@(posedge clk) disable iff (rst)
        (ps == 2'b11 && d_in == 1) |-> detected)
        else $error("Mealy detection failed in s3!");

    // Cover point
    cover property (@(posedge clk) disable iff (rst)
        (ps == 2'b11 && d_in == 1));

endmodule

// =========================================================
// 2. TESTBENCH MODULE
// =========================================================
module tb_fsm_1001_nov;
    logic clk, rst, d_in;
    logic detected;

    fsm_1001_nov dut (
        .clk(clk),
        .rst(rst),
        .d_in(d_in),
        .detected(detected)
    );

    // Bind the SVA module to the DUT
    bind fsm_1001_nov fsm_1001_sva u_sva (
        .clk(clk),
        .rst(rst),
        .d_in(d_in),
        .detected(detected),
        .ps(ps) 
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_fsm_1001_nov);

        rst  = 1;
        d_in = 0;

        #12; 
        rst = 0;

        #10; d_in = 1;
        #10; d_in = 0;
        #10; d_in = 0;
        #10; d_in = 1; // Detect happens here
        #10; d_in = 0;
        #10; d_in = 0;
        #10; d_in = 1;
        #20;

        $finish;
    end

    initial begin
        $monitor("Time=%0t | rst=%b d_in=%b | ps=%b detected=%b",
                 $time, rst, d_in, dut.ps, detected);
    end
endmodule
