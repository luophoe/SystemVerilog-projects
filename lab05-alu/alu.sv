module alu import typedefs::*;
(
   input logic [7:0]    accum,
   input logic [7:0]    data,
   input opcode_t       opcode,
   input                clk,
   output logic [7:0]   out,
   output logic         zero
);

timeunit 1ns;
timeprecision 100ps;


always_comb begin
   if (accum == 0)
      zero = 1;
   else
      zero = 0;
end

always_ff@(negedge clk) begin
   unique case (opcode)
      0,1,6,7  :     out <= accum;
      2        :     out <= data + accum;
      3        :     out <= data & accum;
      4        :     out <= data ^ accum;
      5        :     out <= data;
      default  :     out <= 0;
   endcase
end


endmodule
