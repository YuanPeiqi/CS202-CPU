`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 11:48:45
// Design Name: 
// Module Name: IDMemory
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


module dmemory32(read_data,address,write_data,MemWrite,clock);
input clock;//ʱ��
input[31:0] address;//����MemIO�ĵ�ַ
input MemWrite;//dmemдʹ��
input[31:0] write_data;
output[31:0] read_data;
wire  clk;
assign clk = !clock;
RAM ram (
.clka(clk), // input wire clka
.wea(MemWrite), // input wire [0 : 0] wea
.addra(address[15:2]), // input wire [13 : 0] addra
.dina(write_data), // input wire [31 : 0] dina
.douta(read_data) // output wire [31 : 0] douta
);
endmodule
