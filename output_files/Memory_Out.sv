module Memory_Out
(
	input  logic        clk, 
	input  logic        we, 
	input  logic [12:0] address,
	input  logic [15:0] data   [4], 
	output logic [15:0] ramOut [4]
); 
	
	
	
	// Instancias de RAM
	RAM1 ram1(.address(address),  .clock(clk), .data(data[0]), .wren(we), .q(ramOut[0]));
	RAM1 ram2(.address(address),  .clock(clk), .data(data[1]), .wren(we), .q(ramOut[1]));
	RAM1 ram3(.address(address),	.clock(clk), .data(data[2]), .wren(we), .q(ramOut[2]));
	RAM1 ram4(.address(address),	.clock(clk), .data(data[3]), .wren(we), .q(ramOut[3]));
	
endmodule

