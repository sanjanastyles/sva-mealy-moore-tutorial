module fsm_1001_nov(
    input  logic clk, 
    input  logic rst, 
    input  logic d_in,    
    output wire detected   // Changed to wire for assign statement
);

    localparam s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;
    logic [1:0] ps, ns;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) ps <= s0;
        else     ps <= ns;
    end

    always_comb begin 
        ns = s0;         
        case (ps)
            s0: if (d_in) ns = s1; else ns = s0;
            s1: if (!d_in) ns = s2; else ns = s1;
            s2: if (!d_in) ns = s3; else ns = s1;
            s3: begin
                ns = s0; 
            end          
            default: ns = s0;  
        endcase          
    end     

    // --- BUG INJECTION ---
    logic detected_comb, detected_delayed;
    
    always_comb begin
        detected_comb = (ps == s3 && d_in == 1'b1);
    end

    always_ff @(posedge clk) begin
        detected_delayed <= detected_comb; // Delays the output by 1 cycle!
    end
    
    assign detected = detected_delayed; 
    
endmodule
