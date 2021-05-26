`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 19:26:47
// Design Name: 
// Module Name: control32
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


module controller32(
input wire[5:0]   Opcode,            
input wire[5:0]   Function_opcode,
input wire[31:0]  ALU_Result,    //看[31:10]是否为全1
output wire       Jr,            //get
output wire       RegDST,        //get
output wire       ALUSrc,        //get     
output wire       MemRead,      //get
output wire       RegWrite,      //get
output wire       MemWrite,      //get
output wire       Branch,        //get
output wire       nBranch,       //get
output wire       Jmp,           //get
output wire       Jal,           //get
output wire       I_format,      //get
output wire       Sftmd,         //移位标志
output wire[1:0]  ALUOp,          //get
output wire       IORead,         //IO读数据
output wire       IOWrite,        //IO写数据
output wire       MemIOtoReg      //从MemIO读数据
);
wire [21:0] ALU_Result_Ctrl;
wire R_format;
wire Lw,Sw;
wire addu,subu,ori,sll;
assign ALU_Result_Ctrl=ALU_Result[31:10];
assign addu = (R_format && ~Function_opcode==6'b100001)?1'b1:1'b0; //100001R型
assign subu = (R_format && ~Function_opcode==6'b100011)?1'b1:1'b0;  //100011R型
assign sll = (R_format && ~Function_opcode==6'b000000)?1'b1:1'b0;//000000R型
assign ori = (Opcode==6'b001101)? 1'b1:1'b0;               //001101
assign R_format = (Opcode==6'b000000)? 1'b1:1'b0;
assign Lw = (Opcode==6'b100011)? 1'b1:1'b0;                //lw
assign Sw = (Opcode==6'b101011)? 1'b1:1'b0;                //sw
assign Branch = (Opcode==6'b000100)? 1'b1:1'b0;            //beq
assign nBranch = (Opcode==6'b000101)? 1'b1:1'b0;           //bne
assign Jr =((Function_opcode==6'b001000)&&(Opcode==6'b000000)) ? 1'b1 : 1'b0;
assign Jmp = (Opcode==6'b000010)? 1'b1:1'b0;                //j
assign Jal = (Opcode==6'b000011)? 1'b1:1'b0;                //jal
assign RegDST = (Opcode==6'b000000)? 1'b1:1'b0;
assign RegWrite = ( Jr || Sw || Branch || nBranch || Jmp  )? 1'b0:1'b1;
assign I_format = (Opcode[5:3]==3'b001)?1'b1:1'b0;
assign ALUOp = {(R_format || I_format),(Branch || nBranch)};
assign Sftmd = (Opcode==6'b000000 && Function_opcode[5:3] == 3'b000 )? 1'b1:1'b0;
assign ALUSrc = (Opcode[5:3]==3'b001 || Lw || Sw)? 1'b1:1'b0;
assign MemIOtoReg= Lw;      //get
assign MemRead = (Lw && ALU_Result_Ctrl!= 22'b1111111111111111111111)? 1'b1:1'b0;
assign MemWrite = (Sw && ALU_Result_Ctrl!= 22'b1111111111111111111111)? 1'b1:1'b0;
assign IORead = (Lw && ALU_Result_Ctrl== 22'b1111111111111111111111)? 1'b1:1'b0;
assign IOWrite = (Sw && ALU_Result_Ctrl== 22'b1111111111111111111111)? 1'b1:1'b0;
endmodule
