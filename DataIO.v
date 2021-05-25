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
    input wire SwitchCtrl,		//  ��memorio������ַ�߶��߻�õĲ��뿪��ģ��Ƭѡ
    input wire rst,			// ��λ�ź� 
    input wire IORead,              //  �ӿ���������I/O����
    input wire[15:0] Switch_data,  //���������Ķ����ݣ��˴����Բ��뿪��
    output reg[15:0] IORead_data	// ���������������͸�memorio
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
