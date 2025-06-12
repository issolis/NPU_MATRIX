module TOP(
    input  logic clk, 
    input  logic rst, 
    input  logic rx,
	 input  logic press, 
	 input  logic [7:0]  addresstest, 
    output logic tx,
    output logic [7:0] rxData,
    output logic [6:0] seg0,  
    output logic [6:0] seg1,    
	 output logic [6:0] seg2, seg3, 
	 output logic endF
);

	

    logic [7:0] txData;  
    logic txEn, txDone, rxDone; 
    logic [31:0] byte_count, addressOutCount;
	
	 logic [15:0] ramOut [4], ramOut1 [4]; 
	 logic [15:0] rawOut [4];
	 logic we_mem; 
	 logic done; 
	 logic en_mem_out; 
	 logic [15:0] address_mem_in;
	 logic [15:0] address_mem_out;  
	 
	
	 
    
	 
	 assign we_mem = byte_count < 65536;  
	 assign address_mem_in = we_mem ? byte_count[15:0] : addressOutCount * 2; 
	 assign en_mem_out = ~we_mem && addressOutCount < 8192; 
	 assign txEn = ~ en_mem_out; 
	 
	 
	 assign address_mem_out = en_mem_out ? addressOutCount[15:0] : {7'b0, addresstest}; 
	  
	 assign endF = addressOutCount < 8192; 
	
 
    
    UART uart (
        .Clk(clk),
        .Rst_n(rst), 
        .Rx(rx),
        .TxData(txData),
        .TxEn(txEn), 
        .TxDone(txDone),
        .RxDone(rxDone),
        .Tx(tx),
        .RxData(rxData)
    );
	 
    bytesCounterRX counterRX (
        .clk(clk),
        .rst(rst),
        .rxDone(rxDone),
        .byte_count(byte_count)
    );
	 
	  
	 Memory mem
	(
		.clk(clk),
		.rst(rst), 
		.we(we_mem), 
		.address_in(address_mem_in),
		.data_in(rxData), 
		.addresstest(addresstest), 
		.ramOut(ramOut)
	); 
	
	
	
	
	
	NPU npu (
		.clk(clk),
		.rst(rst),
	   .enable(en_mem_out),
		.raw_in(ramOut),
		.raw_out(rawOut),
		.done(done)
	);
	 
	bytesCounterRX #(
		  .MAX_COUNT(8192)  
	) address_out (
		  .clk(clk),
		  .rst(rst),
		  .rxDone(done),
		  .byte_count(addressOutCount)
	);

	
	Memory_Out mem_out (
    .clk(clk), 
    .we(done),
    .address(address_mem_out),
    .data(rawOut),
    .ramOut(ramOut1)
	);

	
	// TX 

	
	
  	 sevenSeg display0 (
		 ramOut1[0][3:0],
		 seg0
	 );
	 
	 sevenSeg display1 (
		ramOut1[0][7:4], 
		seg1
	 );
	 
	  sevenSeg display2 (
		ramOut1[0][11:8], 
		seg2
	 );
	 
	 sevenSeg display3 (
		ramOut1[0][15:12], 
		seg3
	 );
	 	
    assign txData = ramOut[0][7:0];

endmodule
