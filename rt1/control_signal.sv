`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2026 14:04:17
// Design Name: 
// Module Name: control_signal
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: RISC-V Control Unit Decoder
// 
//////////////////////////////////////////////////////////////////////////////////

module control_signal(
    input  logic [6:0] opcode,
    output logic       regwrite,
    output logic       alusrc,    
    output logic       memread,
    output logic       memwrite,
    output logic [1:0] memtoreg,  
    output logic       branch,
    output logic       jal,
    output logic       jalr,
    output logic       lui,           
    output logic       auipc,     
    output logic [1:0] alu_op       
);

    // Define RISC-V Opcode constants (standard RV32I base instruction set)
    localparam [6:0] R_TYPE  = 7'b0110011;
    localparam [6:0] I_ALU   = 7'b0010011;
    localparam [6:0] LOAD    = 7'b0000011;
    localparam [6:0] STORE   = 7'b0100011;
    localparam [6:0] BRANCH  = 7'b1100011;
    localparam [6:0] JAL     = 7'b1101111;
    localparam [6:0] JALR    = 7'b1100111;
    localparam [6:0] LUI     = 7'b0110111;
    localparam [6:0] AUIPC   = 7'b0010111;

    always_comb begin
        // Default control signal values
        regwrite  = 1'b0;
        alusrc    = 1'b0;
        memread   = 1'b0;
        memwrite  = 1'b0;
        memtoreg  = 2'b00;
        branch    = 1'b0;
        jal       = 1'b0;
        jalr      = 1'b0;
        lui       = 1'b0;
        auipc     = 1'b0;
        alu_op    = 2'b00;
        
        case (opcode)
            R_TYPE: begin
                regwrite = 1'b1;
                alu_op   = 2'b10;
            end

            I_ALU: begin
                regwrite = 1'b1;
                alusrc   = 1'b1;
                alu_op   = 2'b11;
            end

            LOAD: begin
                regwrite = 1'b1;
                alusrc   = 1'b1;
                memread  = 1'b1;
                memtoreg = 2'b01;
                alu_op   = 2'b00;   // address = rs1 + imm
            end

            STORE: begin
                alusrc   = 1'b1;
                memwrite = 1'b1;
                alu_op   = 2'b00;    // address = rs1 + imm
            end

            BRANCH: begin
                branch   = 1'b1;
                alu_op   = 2'b01;
            end

            JAL: begin
                regwrite = 1'b1;
                jal      = 1'b1;
                memtoreg = 2'b10;   // rd = PC + 4
            end

            JALR: begin
                regwrite = 1'b1;
                jalr     = 1'b1;
                alusrc   = 1'b1;    // target = rs1 + imm
                memtoreg = 2'b10;   // rd = PC + 4
                alu_op   = 2'b00;
            end

            LUI: begin
                regwrite = 1'b1;
                alusrc   = 1'b1;
                lui      = 1'b1;     // 0 + imm
                alu_op   = 2'b00;
            end

            AUIPC: begin
                regwrite = 1'b1;
                alusrc   = 1'b1;
                auipc    = 1'b1;     // PC + imm
                alu_op   = 2'b00;
            end
            
            default: begin
                // Keep default safe values assigned above
            end
        endcase         
    end

endmodule
