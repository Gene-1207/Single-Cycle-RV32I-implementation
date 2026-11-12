
module single_cycle_riscv (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,

    input  logic [31:0] instruction,
    input  logic [31:0] mem_out,

    output logic [31:0] rs2_data,
    output logic [31:0] alu_out,
    output logic        mem_write,
    output logic        mem_read,
    output logic [2:0]  fn3,
    output logic [6:0]  opcode,
    output logic [31:0] address
);

    // Internal signals
    logic [31:0] pc_new, rs1_data, imm_out;
    logic [31:0] wb_data, pc_ex_out;

    logic [4:0] rs1, rs2, rd;

    logic [11:0] imm;
    logic [19:0] imm_uj;
    logic [6:0] imm11_5;

    logic fn7_5;

    logic regwrite, alusrc;
    logic branch, jal, jalr, lui, auipc;
    logic and_out_ex;

    logic [1:0] memtoreg;
    logic [1:0] alu_op;
    logic [2:0] aluop_ex;


    // --------------------------------
    // 1. INSTRUCTION FETCH
    // --------------------------------

    Instruction_Fetch IF (
        .clk              (clk),
        .reset            (reset),
        .stall            (stall),
        .and_out          (and_out_ex),
        .pc_signed_offset (pc_ex_out),
        .address          (address),
        .pc_new           (pc_new)
    );


    // --------------------------------
    // 2. INSTRUCTION DECODER
    // --------------------------------

    Decoder ID (
        .instruction (instruction),
        .rs1         (rs1),
        .rs2         (rs2),
        .rd          (rd),
        .opcode      (opcode),
        .imm11_5     (imm11_5),
        .fn3         (fn3),
        .imm         (imm),
        .imm_uj      (imm_uj),
        .fn7_5       (fn7_5)
    );


    // --------------------------------
    // 3. REGISTER FILE
    // --------------------------------

    register_file RF (
        .clk       (clk),
        .reset     (reset),
        .rs1_sel   (rs1),
        .rs2_sel   (rs2),
        .rd_sel    (rd),
        .wb_data   (wb_data),
        .reg_write (regwrite),
        .rs1_data  (rs1_data),
        .rs2_data  (rs2_data)
    );


    // --------------------------------
    // 4. IMMEDIATE GENERATOR
    // --------------------------------

    imm_generator IMM (
        .imm_input    (imm),
        .fn3          (fn3),
        .opcode       (opcode),
        .imm_input_uj (imm_uj),
        .imm_output   (imm_out)
    );


    // --------------------------------
    // 5. CONTROL UNIT
    // --------------------------------

    control_signal CU (
        .opcode   (opcode),
        .regwrite (regwrite),
        .alusrc   (alusrc),
        .memread  (mem_read),
        .memwrite (mem_write),
        .memtoreg (memtoreg),
        .branch   (branch),
        .jal      (jal),
        .jalr     (jalr),
        .lui      (lui),
        .auipc    (auipc),
        .alu_op   (alu_op)
    );


    // --------------------------------
    // 6. ALU OPERATION MAPPING
    // --------------------------------

    always_comb begin
        case (opcode)

            7'b0110011: aluop_ex = 3'b000; // R-type
            7'b0010011: aluop_ex = 3'b001; // I-type
            7'b0000011: aluop_ex = 3'b010; // Load
            7'b0100011: aluop_ex = 3'b011; // Store
            7'b1100011: aluop_ex = 3'b100; // Branch

            default:    aluop_ex = 3'b110; // Jumps / U-type
        endcase
    end


    // --------------------------------
    // 7. EXECUTION STAGE
    // --------------------------------

    ex_stage EX (
        .rs1_data   (rs1_data),
        .rs2_data   (rs2_data),
        .imm_out    (imm_out),
        .address    (address),
        .branch     (branch),
        .alu_src    (alusrc),
        .fn7_5      (fn7_5),
        .mux_inp    (jalr),
        .fn3        (fn3),
        .imm11_5    (imm11_5),
        .aluop      (aluop_ex),
        .opcode     (opcode),
        .and_out_ex (and_out_ex),
        .alu_out    (alu_out),
        .pc_ex_out  (pc_ex_out)
    );


    // --------------------------------
    // 8. WRITE BACK STAGE
    // --------------------------------

    wb_stage WB (
        .mem_out         (mem_out),
        .alu_out         (alu_out),
        .return_addr     (pc_new),
        .imm_out         (imm_out),
        .pc_signed_offset(pc_ex_out),
        .memtoreg        (memtoreg),
        .opcode_out_d    (opcode),
        .wb_data         (wb_data)
    );

endmodule
