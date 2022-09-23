module scale_mux #( parameter WIDTH = 8)
(
   input logic [WIDTH - 1:0]   in_a,
   input logic [WIDTH - 1:0]   in_b,
   input                       sel_a,
   output logic [WIDTH - 1:0]  out
);

timeunit 1ns;
timeprecision 100ps;  


always_comb
unique case(sel_a)
   1        :  out = in_a;
   0        :  out = in_b;
   default  :  out = 1;
endcase


endmodule
