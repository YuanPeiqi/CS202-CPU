`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/18 18:59:20
// Design Name: 
// Module Name: DataIO
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
module DataIO(
    input wire SwitchCtrl,		//  从memorio经过地址高端线获得的拨码开关模块片选
    input wire rst,			// 复位信号 
    input wire IORead,              //  从控制器来的I/O读，
    input wire[15:0] Switch_data,  //从外设来的读数据，此处来自拨码开关
    output reg[15:0] IORead_data	// 将外设来的数据送给memorio
    );
always @* begin
    if(rst == 1)
        IORead_data = 16'h0000;
    else if(IORead == 1) begin
        if(SwitchCtrl == 1)
        IORead_data = Switch_data;
        else   
        IORead_data = IORead_data;
    end
end
endmodule
