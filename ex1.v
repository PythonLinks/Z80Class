//-----------------------------------------------------------------------------
//
// Description : Z80 Test unit
//
//-----------------------------------------------------------------------------
`default_nettype none

`timescale 1ns / 100ps

module EX1_tb;

//Internal signals declarations:
reg CLK;
reg nCLR;
reg CE;
wire [15:0]ADDR;
//reg [7:0]DI;
wire [7:0] DQ;
wire nRD;
wire nWR;
wire nMREQ;
wire nIORQ;
wire nM1;
wire nWAIT;
reg nINT;
wire [2:0] TS;
wire	   nBUSRQ;
wire	   nBUSAK;
   
// Unit Under Test port map
TV80_CPU
	#(.RESET_VECTOR(16'h0000))
CPU_0 (
	.CLK(CLK),
	.nCLR(nCLR),
	.CE(CE),
	.ADDR(ADDR),
	.DQ(DQ),
	.nRD(nRD),
	.nWR(nWR),
	.nMREQ(nMREQ),
	.nIORQ(nIORQ),
	.nINT(nINT),
	.nNMI(1'b1),
	.nBUSRQ(nBUSRQ),
	.nBUSAK(nBUSAK),
	.nWAIT(nWAIT),
	.nM1(nM1),
	.TS(TS));

BUS bus (   .clock(CLK), 
            .nBUSRQ(nBUSRQ), 
            .nBUSAK(nBUSAK),
            .nRD(nRD),
            .nWR(nWR), 
            .ADDR(ADDR),
            .DQ(DQ));

initial
  begin
  //nBUSRQ = 1'b1;
  //nBUSAK = 1'b1;
  end
   
wire RAM_4K_CS = ~(~nMREQ & ~ADDR[15] & ~ADDR[14] & ~ADDR[13] & ~ADDR[12]);

RAM_4K M0(
	.A(ADDR[11:0]),
	.nOE(nRD),
	.nWE(nWR),
	.nCS(RAM_4K_CS),
	.DQ(DQ));

initial
  $display("ADDR    DQ ACC    PC  IR   1   2   SUM ");
   
//Print out registers content at beginning of machine cycle
always @(negedge nM1) begin
//always @(*) begin   
   $display (ADDR, " ", 
     DQ, "  ",
     CPU_0.CPU.ACC, " ",
     CPU_0.CPU.PC, " ",
     CPU_0.CPU.IR, " ",	     	     
     M0.MEM[12'h10], " ",
     M0.MEM[12'h11], " ", 	     
     M0.MEM[12'h12]	     
);
end



   /*
//Stop simulation when IO write -> IO:0x80 = 0xFF
always @(posedge CLK) begin  //WAS FF not )0F
   if ((ADDR == 8'hFF) && //WHEN THE ADDRESS IS 0xFF 
       (nIORQ ==0)  &&   // AND THERE IS AN IO REQUEST
       (nWR ==0))       // AND THERE IS A WRITE REQUEST
     //$display("RESULT = ", M0.MEM[18]);
   
     $finish;
end
    */
   
initial
  begin
  #1000; 
  $finish();
end
   
initial	begin
	CLK = 1'b0;
	forever #5 CLK = ~CLK;
end

assign nWAIT = 1'b1; //No WAIT - Run with full speed

initial begin
	CE = 1'b1;
	nCLR = 1'b0;
	nINT = 1'b1;
	WAIT(20);
	nCLR = 1'b1;
	WAIT(800);
	$display("@%d: Simulation completed.", $time);
	//#1000 $finish;
end

initial begin
	$dumpfile("ex1.vcd");
	$dumpvars(0, EX1_tb);
	$dumpon;
end

//---------------------------------------------------------
//  Included program - use memory tasks to prepare the program
//---------------------------------------------------------

//`include "../tv80_lib/tv80_mul.v"
   
task WAIT;
input [31:0] dy;
begin
	repeat(dy)
	@(negedge CLK);
end
endtask

endmodule

  
