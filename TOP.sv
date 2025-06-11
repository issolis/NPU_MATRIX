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
	 output logic [7:0] seg2
);

	

    logic [7:0] txData;  
    logic txEn, txDone, rxDone; 
    logic [31:0] byte_count;
	
	 logic [15:0] ramOut [4]; 
	 
	
	 
    assign txEn = byte_count[3:0] == 4'b0000; 

    
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
	 

  	 sevenSeg display0 (
		 ramOut[0][3:0],
		 seg0
	 );
	 
	 sevenSeg display1 (
		ramOut[0][7:4], 
		seg1
	 );
	 
	  sevenSeg display2 (
		addresstest[3:0], 
		seg2
	 );
	 
	 
	 Memory mem
	(
		.clk(clk),
		.rst(rst), 
		.address_in(byte_count[15:0]),
		.data_in(rxData), 
		.addresstest(addresstest), 
		.ramOut(ramOut)
	); 
	
	
    assign txData = ramOut[0][7:0];

endmodule
