module Control(opcode, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, SignExtend);
  input [5:0] opcode;
  output wire RegWrite, Branch, ALUSrc, MemRead, MemWrite, Jump, SignExtend;
  output wire [1:0] ALUOp, RegDst, MemtoReg;
  
  parameter [5:0]
    RFORMAT = 6'b000000,
    ADDI = 6'b001000,
    ANDI = 6'b001100,
    LW = 6'b100011,
    SW = 6'b101011,
    BEQ = 6'b000101,
    JAL = 6'b000011;

  wire LOAD = (opcode == LW);
  wire STORE = (opcode == SW);

  assign #10 Jump = (opcode == JAL);
  assign #10 Branch = (opcode == BEQ);
  assign #10 MemRead = LOAD;
  assign #10 MemWrite = STORE;
  assign #10 ALUSrc = (opcode == ADDI || opcode == ANDI || LOAD || STORE);
  assign #10 RegDst[1] = (opcode == JAL);
  assign #10 RegDst[0] = (opcode == RFORMAT);
  assign #10 MemtoReg[1] = (opcode == JAL);
  assign #10 MemtoReg[0] = LOAD;
  assign #10 RegWrite = (opcode == RFORMAT || opcode == ADDI || opcode == ANDI || LOAD || opcode == JAL);
  assign #10 ALUOp[1] = (opcode == RFORMAT || opcode == ANDI);
  assign #10 ALUOp[0] = (opcode == ANDI || opcode == BEQ);

  assign #10 SignExtend = !(opcode == ANDI);
endmodule

module Control_testbench();
  reg [5:0] opcode;
  wire RegWrite, Branch, ALUSrc, MemRead, MemWrite, Jump;
  wire [1:0] ALUOp, RegDst, MemtoReg;

  Control control(opcode, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump);

  parameter [5:0]
    RFORMAT = 6'd0,
    ADDI = 6'd8,
    ANDI = 6'd12,
    LW = 6'd35,
    SW = 6'd43,
    BEQ = 6'd4,
    JAL = 6'd3;

  initial begin
    # 10 opcode = RFORMAT;
    # 10 opcode = ADDI;
    # 10 opcode = ANDI;
    # 10 opcode = LW;
    # 10 opcode = SW;
    # 10 opcode = BEQ;
    # 10 opcode = JAL;
    # 10 $finish;
  end

endmodule

