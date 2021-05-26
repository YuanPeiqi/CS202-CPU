`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/18 12:41:29
// Design Name: 
// Module Name: memorio
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


module MemIO(Addr_Result,address, MemRead,MemWrite,IORead,IOWrite,Mem_read_data,IORead_Data,wdata,rdata,write_data,LedCtrl,SwitchCtrl,SegmentCtrl);
    //input
    input wire[31:0]      Addr_Result;         // from alu_result in executs32
    input wire            MemRead;				// read from memory, from control32
    input wire            MemWrite;				// write from memory, from control32
    input wire            IORead;				// read from IO, from control32
    input wire            IOWrite;				// write form IO, from control32
    input wire[31:0]      Mem_read_data;		// data from memory
    input wire[15:0]      IORead_Data;	        // data from io,16 bits
    input wire[31:0]      wdata;			    // the data want to write memory or io
    //output
    output wire[31:0]     rdata;			        // data from memory or IO that want to read into register
    output reg[31:0]      write_data;            // data to memory or I/O
    output wire[31:0]     address;                // address to memory and I/O
	output wire           SegmentCtrl;           //Digit tube
    output wire           LedCtrl;				 // Led control from controller
    output wire           SwitchCtrl;           // Switch control from controller
    
    wire IO;
    assign  IO=(IOWrite||IORead);
    assign  address = Addr_Result;
    assign  rdata = (MemRead==1) ? Mem_read_data:{16'h0000,IORead_Data[15:0]};
    assign	LedCtrl = ((IO==1) && (Addr_Result[31:4] == 28'hFFFFFC6)) ? 1'b1:1'b0;
    assign  SwitchCtrl = ((IO==1) && (Addr_Result[31:4] == 28'hFFFFFC7)) ? 1'b1:1'b0;
    assign  SegmentCtrl = ((IO==1) && (Addr_Result[31:4] == 28'hFFFFFD0||Addr_Result[31:4] == 28'hFFFFFD1
                                ||Addr_Result[31:4] == 28'hFFFFFD2||Addr_Result[31:4] == 28'hFFFFFD3
                                ||Addr_Result[31:4] == 28'hFFFFFD4||Addr_Result[31:4] == 28'hFFFFFD5
                                ||Addr_Result[31:4] == 28'hFFFFFD6||Addr_Result[31:4] == 28'hFFFFFD7)) ? 1'b1:1'b0;                            
    always @* 
    begin
        if((MemWrite==1)||(IOWrite==1)) //????????????????????????????????????????????????
        begin
        write_data = wdata;
        end 
        else 
        begin
        write_data = 32'h00000000;
        end
        end
endmodule