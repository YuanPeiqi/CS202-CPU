`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/09 16:08:02
// Design Name: 
// Module Name: ifetc32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Ifetc32(
 // input
input wire[31:0]  Addr_result,
input wire[31:0]  Read_data_1,
input wire        Branch,
input wire        nBranch,
input wire        Jmp,
input wire        Jal,
input wire        Jr,
input wire        Zero,
input wire        clock,
input wire        reset,   //1'b1 is 'reset' enable, 1'b0 means 'reset' disable. while 'reset' enable, the value of PC is set as 32'h0000_0000
   // output
output wire[31:0] Instruction,        
output wire[31:0] branch_base_addr,
output reg[31:0]  link_addr,
output wire[31:0] pco      // bind with the new output port 'pco' in IFetc32 
    );
reg[31:0] PC,Next_PC;
always @* 
begin
    if(((Branch == 1) && (Zero == 1 )) || ((nBranch == 1) && (Zero == 0))) // beq, bne
    Next_PC = Addr_result*4; // the calculated new value for PC
    else if(Jr == 1) Next_PC = Read_data_1*4; // the value of $31 register
    else Next_PC =PC+4;// PC+4
end
always @(negedge clock) 
begin
    if(reset == 1)
    PC <= 32'h0000_0000;
    else 
    begin
    if((Jmp == 1) || (Jal == 1)) 
    begin
    link_addr = (PC+4)/4;
    PC <= {4'b0000,Instruction[25:0],2'b00};
    end
    else PC <= Next_PC;
    end
end
assign branch_base_addr=PC+4;
assign pco=PC;
prgrom instmem(.clka(clock),.addra(PC[15:2]),.douta(Instruction));
endmodule
