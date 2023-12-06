`default_nettype none

parameter TRUE = 1'b1;
parameter FALSE = 1'b0;

module BUS (input clock, 
            input nBUSREQ, 
            input nBUSAK,
	    input readData,
	    input writeData,
            inout nRD,
            inout nWR, 
            inout ADDR,
            inout DATA);

   reg		  hasControl;
   reg [1:0]	  fourCount;
   reg [7:0]	  localData;
   reg		  isWorking;
   
always @(negedge clock, posedge clock)
     if (isWorking)//OR IF STARTING
       Fourcount <= fourCount + 1'b1;
     else
       fourCount <= 0

always @(posedge clock)
    casez ({threeCount, isReading, isWriting})
    {3'd0}: TRUE: FALSE}:
    {3'd1}: TRUE: FALSE}:
    {3'd2}: TRUE: FALSE}:
    {3'd3}: TRUE: FALSE}:
    {3'd4}: TRUE: FALSE}:
    {3'd5}: TRUE: FALSE}:      


    4'b??10: ADDR <= localAddress;
    4'b??01: ADDR <= localAddress;      
    //NOW FOR WRITING DATA  
    {3'd0}: FALSE,TRUE}:
        begin
        DATA <= localData;
        nRd <=  'Z';
        nWr <=  'Z';
        end
    {3'd1}:  FALSE, TRUE}:
        begin
        DATA <= localData;
        nRd <=  'Z';
        nWr <=  'Z';
        end  
    {3'd2}:  FALSE, TRUE}:
        begin
        DATA <= localData;
        nRd <=  'Z';
        nWr <=  'Z';
        end
    {3'd3}:  FALSE, TRUE}:
        begin
        DATA <= localData;
        nRd <=  'Z';
        nWr <=  'Z';
        end
    {3'd4}:  FALSE, TRUE}:
        begin
        DATA <= localData;
        nRd <=  'Z';
        nWr <=  'Z';
        end    {3'd5}:  FALSE, TRUE}:      
    default:
        begin
        DATA <= 'Z';
	ADDR <= localAddress;
        nRd <=  'Z';
        nWr <=  'Z';
        end  
   endcase
      
    
always @(negedge nBUSAK )
   ADDR <= 16'b1111;
   timer <=
 
   DATA <= 8'b1111;  


initial 
  output data = 8'b1111_0000;
   
