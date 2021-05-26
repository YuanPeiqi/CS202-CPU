`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 16:02:26
// Design Name: 
// Module Name: CPU_sim
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


module CPU_sim();
    reg           clk=1'b0;
    reg           rst=1'b1;
    reg[23:0]     switch=24'b0;    
    wire[23:0]    led;
    wire[7:0]     DIG;//八位使能信号
    wire[7:0]     Y;//点亮数码管
//    wire    clkout1;
//    wire [31:0] Ins;
//    wire[31:0] reg18;
//    wire switchout;
//    wire ledout;
//    wire prstout;
//    wire[31:0] aluout;
//    wire[31:0] read1out;
//    wire[31:0] read2out;
//    wire[31:0] writedata;
//    wire[31:0] numout;
//    wire alusrc;
//    wire[31:0] wdout;
//    wire iowriteout;
    top_cpu u1(.clk(clk),.rst(rst),.switch(switch),.led(led),.DIG(DIG),.Y(Y));//,.clkout(clkout1),.Ins(Ins),.aluout(aluout),.reg18(reg18),.read2out(read2out),.wdout(writedata),.numout(numout));
    always #5 
    begin
    clk=~clk;
    end
    
    initial
    begin
    #10000
    begin
    rst=0;
    end
    #100000
    switch=24'h001234;
    #100000
    switch=24'h001111;
    #100000
    switch=24'h01ffff;
    #100000
        switch=24'h021234;
     #100000
        switch=24'h031111;
     #10000
        switch=24'h04ffff;
     #100000
         switch=24'h051111;
     #100000
        switch=24'h06ffff;
    #100000
            switch=24'h081234;
            #100000
            switch=24'h080a06;
            #100000
            switch=24'h09060a;
            #100000
                switch=24'h0a0000;
             #100000
             switch=24'h0b0000;
             #100000
                switch=24'h0c0000;
             #100000
                 switch=24'h0d0000;
             #100000
                switch=24'h0e0000;
                #100000
             switch=24'h0f0000;
    end
endmodule
