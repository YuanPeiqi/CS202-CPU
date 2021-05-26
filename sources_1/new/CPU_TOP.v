module top_cpu(clk,rst,led,switch,DIG,Y);//,clkout,Ins,aluout,read1out,read2out,reg18,wdout,numout);

input           clk;
input           rst;
input[23:0]     switch;    
output[23:0]    led;
output[7:0]     DIG;//八位使能信号
output[7:0]     Y;//点亮数码管  
//output          clkout;
//output[31:0]    Ins;
////output switchout;
////output ledout;
////output prstout;
//output[31:0] aluout;
//output[31:0] read1out;
//output[31:0] read2out;
//output[31:0] reg18;
//output[31:0] wdout;
//output[31:0] numout;
wire prst;     
assign prst = ~rst;
wire clock;
wire [31:0]     Instruction;
wire [31:0]     PC_plus_4;
wire [31:0]     Addr_Result; 
wire [31:0]     Read_data_1; 
wire Branch,nBranch,Jmp,Jal,Jr,Zero;
wire [31:0]     opcplus4;   //将要跳转到的指令的地址
wire[31:0]      pco;
wire [31:0]     Read_data_2; 
wire [31:0]     read_data;
wire            RegWrite; 
wire            RegDst; 
wire[31:0]      imme_extend;
wire            ALUSrc;  
wire            MemRead; 
wire            MemWrite;
wire            I_format;
wire            Sftmd;
wire [1:0]      ALUOp;
wire [4:0]      Shamt;
wire [31:0]     ALU_Result;  
wire[31:0]      address; 
wire[31:0]      write_data; 
wire            IORead;				// read IO, from control32
wire            IOWrite;				// write IO, from control32
wire[15:0]      IORead_Data;	
wire[31:0]      rdata;	
wire            MemIOtoReg; 
wire            SegmentCtrl;
wire            LedCtrl;				// Led control from controller
wire            SwitchCtrl;            // Switch control from controller
wire [15:0]     Switch_data;
//assign clkout=clock;
//assign Ins=Instruction; 
//assign aluout=ALU_Result;
//assign read1out=Read_data_1;
//assign read2out=Read_data_2;
//assign wdout=write_data;
//assign alusrc=ALUSrc;
//assign switchout=SwitchCtrl;
//assign ledout=LedCtrl;
//assign prstout=prst;
//assign wdout=rdata;
//assign iowriteout=IOWrite;
    Segment segment(
        .ctrl(SegmentCtrl),
        .number(write_data),
        .DIG(DIG),
        .Y(Y),
        .clk(clock),
        .rst_n(prst)
//        .numout(numout)
        );
        
  
    cpuclk cpuclk(
        .clk_in1(clk),
        .clk_out1(clock)
    );
    
    
    IDecode32 decode(
        .read_data_1(Read_data_1),
        .read_data_2(Read_data_2),
        .Instruction(Instruction),
        .read_data(rdata),
        .ALU_Result(ALU_Result),
        .Jal(Jal),
        .RegWrite(RegWrite),
        .MemIOtoReg(MemIOtoReg),
        .RegDst(RegDst),
        .imme_extend(imme_extend),
        .clock(clock),
        .reset(rst),
        .opcplus4(opcplus4)
//        .reg18(reg18)
    );


    dmemory32 memory(
        .read_data(read_data),
        .address(address),
        .write_data(write_data),
        .MemWrite(MemWrite),
        .clock(clock)
    );


    MemIO memio(
        .Addr_Result(ALU_Result),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .IORead(IORead),
        .IOWrite(IOWrite),
        .Mem_read_data(read_data),
        .IORead_Data(IORead_Data),
        .wdata(Read_data_2),
        .rdata(rdata),
        .write_data(write_data),
        .address(address),
        .SegmentCtrl(SegmentCtrl),
        .LedCtrl(LedCtrl),
        .SwitchCtrl(SwitchCtrl)
    );


    DataIO dataio(
        .SwitchCtrl(SwitchCtrl),
        .rst(!prst),
        .IORead(IORead),
        .Switch_data(Switch_data),
        .IORead_data(IORead_Data)
    );


    controller32 control(
        .Opcode(Instruction[31:26]),
        .Function_opcode(Instruction[5:0]),
        .ALU_Result(ALU_Result),
        .Jr(Jr),
        .RegDST(RegDst),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .IORead(IORead),
        .IOWrite(IOWrite),
        .Branch(Branch),
        .nBranch(nBranch),
        .MemIOtoReg(MemIOtoReg),
        .Jmp(Jmp),
        .Jal(Jal),
        .I_format(I_format),
        .Sftmd(Sftmd),
        .ALUOp(ALUOp)
    );


    Executs32 execute(
        .Read_data_1(Read_data_1),
        .Read_data_2(Read_data_2),
        .Imme_extend(imme_extend),
        .Function_opcode(Instruction[5:0]), 
        .opcode(Instruction[31:26]),
        .ALUOp(ALUOp),
        .Shamt(Instruction[10:6]),  
        .ALUSrc(ALUSrc),
        .I_format(I_format),
        .Zero(Zero),
        .Jr(Jr),
        .Sftmd(Sftmd),
        .ALU_Result(ALU_Result),    
        .Addr_Result(Addr_Result),
        .PC_plus_4(PC_plus_4)
    );

    Ifetc32 ifetch2(
        .Instruction(Instruction),
        .branch_base_addr(PC_plus_4),
        .Addr_result(Addr_Result),
        .Read_data_1(Read_data_1),
        .Branch(Branch),
        .nBranch(nBranch),
        .Jmp(Jmp),
        .Jal(Jal),
        .Jr(Jr),
        .Zero(Zero),
        .clock(clock),
        .reset(rst),
        .link_addr(opcplus4),
        .pco(pco)
    );
    
    leds led16(
        .led_clk(clock),
        .ledrst(rst),
        .ledwrite(IOWrite),
        .ledcs(LedCtrl),
        .ledaddr(address[1:0]),
        .ledwdata(write_data[15:0]),
        .ledout(led)
     );
      
     switchs switch16(
        .switclk(clock),
        .switrst(rst),
        .switchread(IORead),
        .switchcs(SwitchCtrl),
        .switchaddr(address[1:0]),
        .switchrdata(Switch_data),
        .switch_i(switch)
     );
endmodule