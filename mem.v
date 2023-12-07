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
   
always @(nOE or nWE or DQ)
    if (!nCS & !nWE)
	MEM[A] = DQ;
          
   
  
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


initial
  begin
     //FIRST WRITE THE DATA
     wr_addr = 12'h10;     
     WR_MEM(12'd1);
     wr_addr = 12'h11;     
     WR_MEM(12'd2);
 
     //NOW WRITE THE PROGRAM

     wr_addr = 12'd0;     
//   `define LXI_H	8'b00100001     
     WR_MEM(8'b00100001);   //33 LXI_H HL POINTS TO ...
     
     wr_addr = 12'd1;
     WR_MEM(8'h10);   //16 HIGH BITS OF DATA
     wr_addr = 12'd2;
     WR_MEM(8'h00);   //0 LOW BITS OF DATA



     wr_addr = 12'd3;          
//   `define MOV_A_M 8'b01111110
     WR_MEM(8'b01111110); // 126 MOV_A_M GET OPERAND

     
 // `define INX_H	8'b00100011        
     wr_addr = 12'd4;
     WR_MEM(8'b00100011);   //35 INX_H INCREMENT

//`    define ADD_M	8'b10000110     
     wr_addr = 12'd5;
     WR_MEM(8'b10000110);   //134 ADD_M
     
 // `define INX_H	8'b00100011        
     wr_addr = 12'd6;
     WR_MEM(8'b00100011);   //35 INX_H INCREMENT    

//   `define MOV_M_A 8'b01110111     
     wr_addr = 12'd7;
     WR_MEM(8'b01110111); //119 MOV_M_A STORE
     
//   `define HLT		8'b01110110     
     wr_addr = 12'd8;
     WR_MEM(8'b01110110);     //118 HLT HALT

     
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
