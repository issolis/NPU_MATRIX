module Memory 
(
	input  logic        clk, rst, 
	input  logic [15:0] address_in,
	input  logic [7:0]  data_in, 
	input  logic [7:0]  addresstest, 
	output logic [15:0] ramOut [4]
); 
	logic [3:0]  wren; 
	logic [12:0] address;
	logic [15:0] data;

	// Dirección de palabra (cada palabra son 2 bytes)
	assign address = address_in[13:1]; 

	// Ensamblar palabra de 16 bits con 2 escrituras de 8 bits
	always_ff @(posedge clk or negedge rst) begin 
		if (!rst)
			data <= 16'd0; 
		else begin 
			if (address_in[0] == 1'b0)
				data[7:0]  <= data_in; 
			else
				data[15:8] <= data_in; 
		end 
	end

	// Selección de banco según address_in
	always_comb begin 
		wren = 4'b0000;
		if (address_in < 16'h4000)     
			 // 0x0000 – 0x3FFF
			wren = 4'b0001; // RAM1
		else if (address_in < 16'h8000)     // 0x4000 – 0x7FFF
			wren = 4'b0010; // RAM2
		else if (address_in < 16'hC000)     // 0x8000 – 0xBFFF
			wren = 4'b0100; // RAM3
		else                                // 0xC000 – 0xFFFF
			wren = 4'b1000; // RAM4
	end
	
	logic [12:0] address1;
	assign address1 = address_in < 255 ? address : addresstest; 
	logic en; 
	assign en	= address_in < 255 ? wren[0]  : 0;
	
	
	// Instancias de RAM
	RAM1 ram1(.address(address1), .clock(clk), .data(data), .wren(en),      .q(ramOut[0]));
	RAM1 ram2(.address(address),  .clock(clk), .data(data), .wren(wren[1]), .q(ramOut[1]));
	RAM1 ram3(.address(address),	.clock(clk), .data(data), .wren(wren[2]),	.q(ramOut[2]));
	RAM1 ram4(.address(address),	.clock(clk), .data(data), .wren(wren[3]),	.q(ramOut[3]));
	
endmodule

