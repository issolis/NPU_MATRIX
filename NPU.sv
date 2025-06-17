module NPU 
(
	input logic clk, rst, enable, 
	input logic [15:0] raw_in [4], 
	output logic done, 
	output logic [15:0] raw_out [4], 
	output logic [3:0] countOut
); 

	logic [3:0] count;	
	logic en_col_0, en_col_1, en_col_2, en_col_3; 
	logic counterRst; 
	
	logic [15:0] sum_out_00, sum_out_01, sum_out_02, sum_out_03;
	logic [15:0] sum_out_10, sum_out_11, sum_out_12, sum_out_13;
	logic [15:0] sum_out_20, sum_out_21, sum_out_22, sum_out_23;
	
	logic [15:0] self_out_00, self_out_01, self_out_02;
	logic [15:0] self_out_10, self_out_11, self_out_12;	
	logic [15:0] self_out_20, self_out_21, self_out_22;		
	logic [15:0] self_out_30, self_out_31, self_out_32;
	
	
	
	
	
	assign en_col_0 = count < 8;
	assign en_col_1 = count < 7;
	assign en_col_2 = count < 6;
	assign en_col_3 = count < 5;
	assign done     = count == 8;
	 
	assign counterRst = rst && count != 10; 
	assign countOut = count;  
	
	counter counter_inst (.clk(clk),  .rst(counterRst), .enable(enable), .count(count));
	 
	 
	
	// Colum 0 
	
	
	processor #(.WEIGHT(1)) p00(
        .clk(clk),
        .rst(rst),
        .enable(en_col_0),
        .sum_in(16'b0),
        .self_in(raw_in[0]),
        .sum_out(sum_out_00),
        .self_out(self_out_00)
    );
	 
	processor #(.WEIGHT(1)) p10(
       .clk(clk),
       .rst(rst),
       .enable(en_col_0),
       .sum_in(sum_out_00),
       .self_in(raw_in[1]),
       .sum_out(sum_out_10),
       .self_out(self_out_10)
   );
	 
	processor #(.WEIGHT(1)) p20(
       .clk(clk),
       .rst(rst),
       .enable(en_col_0),
       .sum_in(sum_out_10),
       .self_in(raw_in[2]),
       .sum_out(sum_out_20),
       .self_out(self_out_20)
   );
	
	processor #(.WEIGHT(1)) p30(
       .clk(clk),
       .rst(rst),
       .enable(en_col_0),
       .sum_in(sum_out_20),
       .self_in(raw_in[3]),
       .sum_out(raw_out[0]),
       .self_out(self_out_30)
   );
	
	// Colum 1
	
	processor #(.WEIGHT(2)) p01(
        .clk(clk),
        .rst(rst),
        .enable(en_col_1),
        .sum_in(16'b0),
        .self_in(self_out_00),
        .sum_out(sum_out_01),
        .self_out(self_out_01)
    );
	 
	processor #(.WEIGHT(2)) p11(
       .clk(clk),
       .rst(rst),
       .enable(en_col_1),
       .sum_in(sum_out_01),
       .self_in(self_out_10),
       .sum_out(sum_out_11),
       .self_out(self_out_11)
   );
	 
	processor #(.WEIGHT(2)) p21(
       .clk(clk),
       .rst(rst),
       .enable(en_col_1),
       .sum_in(sum_out_11),
       .self_in(self_out_20),
       .sum_out(sum_out_21),
       .self_out(self_out_21)
   );
	
	processor #(.WEIGHT(2)) p31(
       .clk(clk),
       .rst(rst),
       .enable(en_col_1),
       .sum_in(sum_out_21),
       .self_in(self_out_30),
       .sum_out(raw_out[1]),
       .self_out(self_out_31)
   );
	
	//Column 2
	
	processor #(.WEIGHT(3)) p02(
        .clk(clk),
        .rst(rst),
        .enable(en_col_2),
        .sum_in(16'b0),
        .self_in(self_out_01),
        .sum_out(sum_out_02),
        .self_out(self_out_02)
    );
	 
	processor #(.WEIGHT(3)) p12(
       .clk(clk),
       .rst(rst),
       .enable(en_col_2),
       .sum_in(sum_out_02),
       .self_in(self_out_11),
       .sum_out(sum_out_12),
       .self_out(self_out_12)
   );
	 
	processor #(.WEIGHT(3)) p22(
       .clk(clk),
       .rst(rst),
       .enable(en_col_2),
       .sum_in(sum_out_12),
       .self_in(self_out_21),
       .sum_out(sum_out_22),
       .self_out(self_out_22)
   );
	
	processor #(.WEIGHT(3)) p32(
       .clk(clk),
       .rst(rst),
       .enable(en_col_2),
       .sum_in(sum_out_22),
       .self_in(self_out_31),
       .sum_out(raw_out[2]),
       .self_out(self_out_32)
   );
	
	// Column 3
	
	processor #(.WEIGHT(4)) p03(
        .clk(clk),
        .rst(rst),
        .enable(en_col_3),
        .sum_in(16'b0),
        .self_in(self_out_02),
        .sum_out(sum_out_03),
        .self_out()
    );
	 
	processor #(.WEIGHT(4)) p13(
       .clk(clk),
       .rst(rst),
       .enable(en_col_3),
       .sum_in(sum_out_03),
       .self_in(self_out_12),
       .sum_out(sum_out_13),
       .self_out()
   );
	 
	processor #(.WEIGHT(4)) p23(
       .clk(clk),
       .rst(rst),
       .enable(en_col_3),
       .sum_in(sum_out_13),
       .self_in(self_out_22),
       .sum_out(sum_out_23),
       .self_out()
   );
	
	processor #(.WEIGHT(4)) p33(
       .clk(clk),
       .rst(rst),
       .enable(en_col_3),
       .sum_in(sum_out_23),
       .self_in(self_out_32),
       .sum_out(raw_out[3]),
       .self_out()
   ); 
	

endmodule 