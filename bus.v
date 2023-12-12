`default_nettype none
`timescale 1ns / 100ps

module BUS (input clock, 
            //output	 nBUSRQ,
            output       nBUSRQ,
            input	 nBUSAK,
            inout	 nRD,
            inout	 nWR, 
            inout [15:0] ADDR,
            inout [7:0]	 DQ);
   
parameter TRUE = 1'b1;
parameter FALSE = 1'b0;

initial
  begin
      //nBUSRQ = 1'b1;
      //nBUSRQ = 1'bz;     
      //#50 nBUSRQ = 1'b0;     
  end   
endmodule // BUS
