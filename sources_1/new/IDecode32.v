`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/05 16:21:08
// Design Name: 
// Module Name: Idecode32
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


module IDecode32(
// input 
    input wire[31:0]  Instruction,//ָ��
    input wire[31:0]  read_data,//lw��Ҫ�����ݣ���IO��Mem�õ�
    input wire[31:0]  ALU_Result,//������
    input wire        Jal,//jump and link
    input wire        RegWrite,//reg д�ź�ʹ��
    input wire        MemIOtoReg,//��Mem IO��regʹ��
    input wire        RegDst,//�ж�д��rt����rd
    input wire        clock,reset,
    input wire[31:0]  opcplus4,    // from ifetch link_address jal���õ�������ra�Ĵ���
    // output
    output wire[31:0] read_data_1,//��һ������
    output wire[31:0] read_data_2,//�ڶ�������
    output wire[31:0] imme_extend//������չ���32λ������
//    output wire[31:0] reg18
    );
    reg[31:0] register[0:31];
    reg[31:0] writeData;
//    assign reg18=register[18];
    reg[4:0]  writeReg;
    wire[4:0] rs;
    wire[4:0] rt;
    wire[4:0] rd;
    wire[5:0] op;
    assign rs=Instruction[25:21];
    assign rt=Instruction[20:16];
    assign rd=Instruction[15:11];
    assign read_data_1 = register[rs];
    assign read_data_2 = register[rt];
//    assign imme_extend[15:0] = Instruction[15:0];
//    assign imme_extend[31:16] = Instruction[15]? 16'hffff : 16'h0000;
    assign op= Instruction[31:26]; 
    wire sign;                                            // ȡ����λ��ֵ
    assign sign = Instruction[15];
    assign imme_extend[31:0] = ((op==6'b001100)     // andi
                          ||(op==6'b001101)             // ori
                          ||(op==6'b001110)             // xori
                          ||(op==6'b001011))?{{16{1'b0}},Instruction[15:0]}:{{16{sign}},Instruction[15:0]};
    always@*
    begin
    if (MemIOtoReg==1'b0 && Jal==1'b1 ) 
    begin
    writeData = opcplus4;
    end 
    else if(MemIOtoReg==1'b0) 
    begin
    writeData = ALU_Result;
    end 
    else begin
    writeData = read_data;
    end 
    end
    always@*
    begin
    if(RegDst && ~Jal)
    writeReg <= rd;
    else if((RegDst==0) && (Jal==1))
    writeReg <= 5'b11111;
    else
    writeReg <= rt;
    end
    integer j; 
    always@(posedge clock)
        begin
        if(reset)
        begin
        for (j = 0; j < 32; j = j + 1) 
        register[j]<=0;
        end
        else if(RegWrite)
        begin  
        register[writeReg] <= writeData;    
        end 
    end
endmodule
