module UART_rs232_tx (Clk,Rst_n,TxEn,TxData,TxDone,Tx,Tick,NBits);	//Define my module as UART_rs232_tx

input Clk, Rst_n, TxEn,Tick;	//Define 1 bit inputs
input [3:0]NBits;		//Define 4 bits inputs
input [7:0]TxData;		//Define 8 bit inputs

output Tx;
output TxDone;




//Variabels used for state machine...
parameter  IDLE = 1'b0, WRITE = 1'b1;	//We have 2 states for the State Machine state 0 and 1 (WRITE adn IDLE)
reg  State, Next;			//Create some registers for the states
reg  TxDone = 1'b0;			//Variable used to notify when the transmission process is done
reg  Tx;				//We register the input value
reg write_enable = 1'b0;		//Variable used to activate or deactivate the transmission process			
reg start_bit = 1'b1;			//Variable used to notify if the START bit was made or not yet
reg stop_bit = 1'b0;			//Variable used to notify if the STOP bit was made or not yet
reg [4:0] Bit = 5'b00000;		//Variable used for the bit by bit write loop (in this case 8 bits so 8 loops)
reg [3:0] counter = 4'b0000;		//Counter variable used to count the tick pulses up to 16
reg [7:0] in_data=8'b00000000;		//Register where we store tha data that arrived with the TxData input and has to be sent
reg [1:0] R_edge;			//Variable used to avoid debounce of the write enable pin
wire D_edge;				//Wire used to connect the D_edge



///////////////////////////////STATE MACHINE////////////////////////////////
////////////////////////////////////////////////////////////////////////////
///////////////////////////////////Reset////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
always @ (posedge Clk or negedge Rst_n)			//It is good to always have a reset always
begin
if (!Rst_n)	State <= IDLE;				//If reset pin is low, we get to the initial state which is IDLE
else 		State <= Next;				//If not we go to the next state
end




////////////////////////////////////////////////////////////////////////////
////////////////////////////Next step decision//////////////////////////////
////////////////////////////////////////////////////////////////////////////
/* This is easy as well.  Each time "State or D_edge or TxData or TxDone" will 
change their value we decide which is the next step. 
 - If D_edge was detected, so the TxEn was enabeled, we start the write process
 - Obviously, if the TxDone is high, then we get back to IDLE and wait for next TxEn to be activated */
always @ (State or D_edge or TxData or TxDone) 
begin
    case(State)	
	IDLE:	 if (TxEn) Next = WRITE;		
			 else Next = IDLE;		//If we are into IDLE and D_edge gets activated, we start the WRITE process
	
	WRITE:	if(TxDone)		Next = IDLE;  		//If we are into WRITE and TxDone gets high, we get back to IDLE and wait
		else			Next = WRITE;
	default 			Next = IDLE;
    endcase
end



////////////////////////////////////////////////////////////////////////////
///////////////////////////ENABLE WRITE OR NOT//////////////////////////////
////////////////////////////////////////////////////////////////////////////
always @ (State)
begin
    case (State)
	WRITE: begin
		write_enable <= 1'b1;	//If we are in the WRITE state, we enable the write process
	end
	
	IDLE: begin
		write_enable <= 1'b0;	//If we are in the IDLE state, we disable the write process
	end
    endcase
end





////////////////////////////////////////////////////////////////////////////
///////////////////////Write the data out on Tx pin/////////////////////////
////////////////////////////////////////////////////////////////////////////
/*Finally, each time we detect a Tick pulse, if the write_enable is enabeled,
we start counting ticks. First we set the Tx pin to LOW and that indicates a start bit.
Then each 16 ticks, we set the Tx output to a value acording to the "in_data" value which
is the data to eb sent. We do that by shifting the "in_data" using this lines: 
	in_data <= {1'b0,in_data[7:1]};
	Tx <= in_data[0]; */

always @ (posedge Tick)
begin

	if (!write_enable)				//if write_enable is not activated, then we reset all varaibles for enxt loop
	begin
	TxDone = 1'b0;
	start_bit <=1'b1;
	stop_bit <= 1'b0;
	end

	if (write_enable)				//if write_enable is activated, then we start counting and changing the Tx output
	begin
	counter <= counter+1;				//Increase the counter by one each positive edge of the Tick input
	
	
	if(start_bit & !stop_bit)			//We set the Tx to LOW (start bit) and pass the TxData input to the in:data register
	begin
	Tx <=1'b0;					//Create start bit  (low pulse)
	in_data <= TxData;				//Pass the data to eb sent to the in_data register so we could use it
	end		

	if ((counter == 4'b1111) & (start_bit) )	//If counter reaches 16 (4'b1111), then we create the first bit and set "start_bit" to low
	begin		
	start_bit <= 1'b0;
	in_data <= {1'b0,in_data[7:1]};
	Tx <= in_data[0];
	end


	if ((counter == 4'b1111) & (!start_bit) &  (Bit < NBits-1))	//If we reach 16 once again, we make a loop for the next 7 bits (NBits-1)
	begin		
	in_data <= {1'b0,in_data[7:1]};
	Bit<=Bit+1;
	Tx <= in_data[0];
	start_bit <= 1'b0;
	counter <= 4'b0000;
	end	



	
	if ((counter == 4'b1111) & (Bit == NBits-1) & (!stop_bit))	//We finish, so we set Tx to HIGH (Stop bit)
	begin
	Tx <= 1'b1;	
	counter <= 4'b0000;	
	stop_bit<=1'b1;
	end

	if ((counter == 4'b1111) & (Bit == NBits-1) & (stop_bit) )	//If stop bit was enabeled, than we reset the values and wait for enxt write process
	begin
	Bit <= 4'b0000;
	TxDone <= 1'b1;
	counter <= 4'b0000;
	//start_bit <=1'b1;
	end
	
	end
		

end



////////////////////////////////////////////////////////////////////////////
////////////////////////////Input enable detect/////////////////////////////
////////////////////////////////////////////////////////////////////////////
/*Here we detect if there was a reset or if the TxEn was activated.
If "TxEn" was actiavted than we start the write process and we will send
the data that is on the "TxData" input so amke sure that in the 
moment you activate "TxEn" the TxData" has the values you want to send . */
always @ (posedge Clk or negedge Rst_n)
begin

	if(!Rst_n)
	begin
	R_edge <= 2'b00;
	end
	
	else
	begin
	R_edge <={R_edge[0], TxEn};
	end
end
assign D_edge = !R_edge[1] & R_edge[0];





endmodule
