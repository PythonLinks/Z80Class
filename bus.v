`default_nettype none
`timescale 1ns / 100ps

module BUS (clock, 
            nBUSRQ,
            nBUSAK,
            nRD,
            nWR, 
            ADDR,
            DQ);
   input		       clock;
   output                      nBUSRQ;
   input		       nBUSAK;
   inout		       nRD;
   inout		       nWR;
   output  wire [15:0]	       ADDR;
   output  wire [7:0]	       DQ;
	 
   reg 	               request;
   reg [15:0]		 address;
   reg [7:0]		 data;
 
   
   parameter TRUE = 1'b1;
   parameter FALSE = 1'b0;
   assign nBUSRQ = request;
   assign ADDR = address;
   assign DQ = data;
   

always @(negedge nBUSAK)
  begin
     data    <=  8'd111;     
     #3 address <= 16'd170;
     $display ("ADDRESS ", address, " ADDR=", ADDR, " DQ= ", DQ);
     #5 $display ("ADDRESS ", address, " ADDR=", ADDR, " DQ= ", DQ);             
  end    
   
initial
  begin
     address = 16'bz;
     data = 8'bz;
     #700 request = FALSE;
  end   
endmodule // BUS
