module register
   (
   input logic [7:0]    data,
   input                enable,
   input                clk,
   input                rst_,
   output logic [7:0]   out
   );
  
timeunit 1ns;
timeprecision 100ps;


always_ff @(posedge clk or negedge rst_)
   priority if (rst_ && enable)
      out <= data;
   else if (rst_)
      out <= out;
   else
      out <= 0;


endmodule
