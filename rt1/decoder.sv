`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2026 15:33:22
// Design Name: 
// Module Name: Decoder
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


module Decoder(
input logic [31:0]instruction,
output logic [4:0] rs1,
output logic [4:0] rs2,
output logic [4:0] rd,
output logic [6:0] opcode,
output logic [6:0] imm11_5,
output logic [2:0] fn3,
output logic [11:0] imm,
output logic [19:0] imm_uj,
output logic fn7_5
   );
   
   
    
    always_comb begin
    rd= 5'd0;
    fn3= 3'd0;
    rs1= 5'd0;
    rs2= 5'd0;
    imm= 12'd0;
    imm_uj= 20'd0;
    imm11_5= 7'd0;
    fn7_5= 1'd0;
    
    opcode = instruction[6:0]; 
    
    case(opcode)
    
    7'b0110011: begin   // R TYPE
    rd = instruction [11:7];
    fn3 = instruction [14:12];
    rs1 = instruction [19:15];
    rs2 = instruction [24:20];
    fn7_5 = instruction [30];
    end
    
    
    7'b0010011: begin   // I TYPE (ARITHMETIC) 
    rd  = instruction[11:7];
    fn3 = instruction[14:12];
    rs1 = instruction[19:15];
    imm = instruction[31:20];
    
    end
    
    7'b0000011 : begin //I TYPE (LOAD)
    rd  = instruction[11:7];
    fn3 = instruction[14:12];
    rs1 = instruction[19:15];
    imm = instruction[31:20];
    end
    
    
    7'b1100111 : begin //JALR
    rd  = instruction[11:7];
    fn3 = instruction[14:12];
    rs1 = instruction[19:15];
    imm = instruction[31:20];
    end
    
    
    
    7'b0100011: begin      // S TYPE
    imm = instruction [11:7];    
    fn3 = instruction [14:12];
    rs1 = instruction [19:15];
    rs2 = instruction [24:20];
    imm11_5 = instruction [31:25];
    end
    
        7'b1100011: begin      // B TYPE
    imm = instruction [11:8];    
    fn3 = instruction [14:12];
    rs1 = instruction [19:15];
    rs2 = instruction [24:20];
    imm = instruction [30:25];
    imm = instruction [31];
    imm = instruction [7];
    end
    
    7'b1101111: begin      // J TYPE
    rd = instruction [11:7];  
    imm = instruction [30:21];
    imm = instruction [31];
    imm = instruction [20];
    imm = instruction [19:12];
    end
    
    
    7'b0110111: begin      // U TYPE lui
    rd     = instruction[11:7];
    imm_uj = instruction[31:12];
    
    end
    
    7'b00101111: begin      // U TYPE auipc
    rd     = instruction[11:7];
    imm_uj = instruction[31:12];
    end
    

    
    endcase
end
endmodule




   
