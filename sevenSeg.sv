module sevenSeg(input logic [3:0] binary, 
							output logic [6:0] y); 


							
always_comb begin
			case(binary)    //  gfed_cba
				4'b0000 : y = 7'b1000_000; // 0
				4'b0001 : y = 7'b1111_001; // 1
				4'b0010 : y = 7'b0100_100; // 2
				4'b0011 : y = 7'b0110_000; // 3
				4'b0100 : y = 7'b0011_001; // 4
				4'b0101 : y = 7'b0010_010; // 5
				4'b0110 : y = 7'b0000_010; // 6 
				4'b0111 : y = 7'b1111_000; // 7 
				4'b1000 : y = 7'b0000_000; // 8
				4'b1001 : y = 7'b0010_000; // 9
				4'b1010 : y = 7'b0001_000; // 10
				4'b1011 : y = 7'b0000_011; // 11
				4'b1100 : y = 7'b1000_110; // 12
				4'b1101 : y = 7'b0100_001; // 13
				4'b1110 : y = 7'b0000_110; // 14
				4'b1111 : y = 7'b0001_110; // 15
				default: y = 7'b0000_000;
			endcase
		end

							
							
							
endmodule
 