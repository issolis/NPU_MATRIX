module counter #(
	parameter N = 4
)(
	input logic clk, rst, enable, 
	output logic [N-1:0] count
);
	
	logic [N-1:0] auxCount; 
	always @(posedge clk or negedge rst) begin 
		if (~rst) begin 
			auxCount <= 0;   
		end 
		else begin 
			if (enable) begin
				auxCount <= auxCount + 1; 
			end
		end
	end
	
	assign count = auxCount; 

endmodule 


