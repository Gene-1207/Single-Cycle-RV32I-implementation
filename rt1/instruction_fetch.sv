`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2026 14:26:49
// Design Name: 
// Module Name: Instruction_Fetch
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


module Instruction_Fetch(
//2:1MUX
input logic clk,
input logic reset,
input logic stall,
input logic and_out,
input logic pc_signed_offset,
output logic address,
output logic pc__new

    );
 assign pc_new = address + 32'd4;
// assign pc_next = and_out?  pc_signed_offset: pc__new;
logic [31:0] pc_next;
 always_comb begin
 if (and_out)
 pc_next = pc_signed_offset;
 else 
 pc_next = pc_new;
 end
always_ff @(posedge clk or posedge reset)
 begin
 if (reset)
 address <=32'h8000_0000;
 else if (!stall) 
 address <= pc_next;
 end
endmodule
