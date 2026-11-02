module fsm_1001_nov(
    input  logic clk, 
    input  logic rst, 
    input  logic d_in,    
    output wire detected   // <--- CHANGED to 'wire'
);

    localparam s0 = 2'b00;
    localparam s1 = 2'b01;
    localparam s2 = 2'b10;
    localparam s3 = 2'b11;

    logic [1:0] ps, ns;

    always_ff @(posedge clk) begin
        if (rst) ps <= s0;
        else     ps <= ns;
    end

    always_comb begin 
        // REMOVED the default 'detected = 1'b0;' here
        ns = s0;         

        case (ps)
            s0: if (d_in == 1'b1) ns = s1; else ns = s0;
            s1: if (d_in == 1'b0) ns = s2; else ns = s1;
            s2: if (d_in == 1'b0) ns = s3; else ns = s1;
            s3: begin
                ns = s0; 
                // REMOVED the 'detected = 1'b1;' here
            end          
            default: ns = s0;  
        endcase          
    end     

    // BUG INJECTION: We delay 'detected' by one cycle using a register
    logic detected_comb; // The combinational signal
    
    // We need a new always_comb just for the combinational part of detected
    always_comb begin
        detected_comb = 1'b0;
        if (ps == s3 && d_in == 1'b1) begin
            detected_comb = 1'b1;
        end
    end

    logic detected_delayed;
    always_ff @(posedge clk) begin
        detected_delayed <= detected_comb; // The bug: delayed by 1 cycle!
    end
    
    // Assign the delayed signal to the output wire
    assign detected = detected_delayed; 
    
endmodule
