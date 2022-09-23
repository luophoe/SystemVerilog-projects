module counter
(
   input logic [4:0]    data,
   input                load,
   input                enable,
   input                clk,
   input                rst_,
   output logic [4:0]   count
);

timeunit 1ns;
timeprecision 100ps;   


always_ff @(posedge clk or negedge rst_)
   priority if (rst_ && load)
      count <= data;
   else if (rst_ && enable)
      count <= count + 1;
   else if (rst_)
      count <= count;
   else
      count <= 0;


endmodule
