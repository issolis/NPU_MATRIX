module processor 
#(
    parameter WEIGHT = 1
)(
    input  logic        clk, rst, enable,
    input  logic [15:0] sum_in, self_in, 
    output logic [15:0] sum_out, self_out
); 
    logic [15:0] self_value; 

    always_ff @(posedge clk or negedge rst) begin 
        if (~rst) begin 
            sum_out     <= 16'b0;
            self_out    <= 16'b0; 
            self_value  <= 16'b0;
        end else begin 
            if (enable) begin 
                self_value <= self_in; // almacena nuevo valor
					 self_out <= self_in;
            end
            sum_out  <= WEIGHT * self_value + sum_in; // usa el valor anterior de self_value
           
        end 
    end

endmodule
