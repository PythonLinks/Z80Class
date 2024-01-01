`default_nettype none

`timescale 1ns/100ps

  
module RAM_4K(A, nOE, nWE, nCS, DQ);


 
input [11:0] A;
input nOE, nWE, nCS;
inout [7:0] DQ;
wire [ 7:0] result;      
reg [7:0] MEM [4095:0];


//TODO: Implement 4kB RAM with task for loading a content using semi assembler
// start with no values.
   wire   show;
   assign show = (~nCS & ~nOE & nWE) ;
  
   assign DQ = show ? result : 8'hzz;
   assign result = MEM[A] ;
   
always @(nCS or nOE or nWE or DQ) begin
     
    if (~nCS & ~nWE) begin
     //$display("WR %5t %h:%h(%d)", $time, A, DQ, DQ, ~nCS, ~nWE);
       
	MEM[A] = DQ;

    end
 end
          

   
  
//---------------------------------------------------------
// Modelling tasks
//---------------------------------------------------------
//WAS integer   
reg [6:0] label_id;
reg [11:0] wr_addr;
   
   task WR_MEM(   input [7:0] DATA);
 /* write a byte to the memory */
   MEM [wr_addr] = DATA;
endtask

task WR_MEM_W(input [15:0] DATA); /* Write word to the memory array */
   begin
   MEM [wr_addr]        = DATA[7:0];
   MEM [wr_addr + 1'b1] = DATA[15:8];
   end   
endtask

/*
always @ (*)
   if (DQ==118) begin
     $display ("SUM  = ", MEM[12'h12]);
     //$finish;
     end 
  */ 

`include  "../tv80_lib/8085_instr_set.v" 
   
initial
  begin
     //FIRST WRITE THE DATA
     wr_addr = 12'h10;     
     WR_MEM(12'd5);
     wr_addr = 12'h11;     
     WR_MEM(12'd2);
 
     //NOW WRITE THE PROGRAM

     wr_addr = 12'd0;     
     WR_MEM(`LXI_H);   //33 LOAD FROM THE ADDRESS     
     wr_addr = 12'd1;
     WR_MEM(8'h10);   //16 LOW BITS OF DATA
     wr_addr = 12'd2;
     WR_MEM(8'h00);   //0 HIGH BITS OF DATA

     wr_addr = 12'd3;          
     WR_MEM(`MOV_A_M); // 126 

     
 // `define INX_H	8'b00100011        
     wr_addr = 12'd4;
     WR_MEM(8'b00100011);   //35 INX_H INCREMENT

     wr_addr = 12'd5;
     WR_MEM(`ADD_M);   //134 ADD_M

     wr_addr = 12'd6;
     WR_MEM(`ADD_M);   //134 ADD_M
     
     wr_addr = 12'd7;
     WR_MEM(`INX_H);   //35 INX_H INCREMENT

     wr_addr = 12'd8;
     WR_MEM(`MOV_M_A);     //119 MOV_M_A STORE          

     wr_addr = 12'd9;
     WR_MEM(`HLT);     //118 HLT HALT
     
     $display ("OP1  = ", MEM[12'h10]);
     $display ("OP2  = ", MEM[12'h11]);

  end // initial begin


/*         
initial begin
   $display("A     nOE nWE nCS Show Result DQ");
   
   $monitor( A, "  ",  
             nOE,  "   ",
             nWE, "   ",
             nCS, "   ",
	     show, "   ",
	     result, "    ",
             DQ); 
end
*/
   
endmodule
//PROGRAM FROM //PROGRAM FROM
//https://www.tutorialspoint.com/microprocessor/microprocessor_8085_instruction_sets.htm
