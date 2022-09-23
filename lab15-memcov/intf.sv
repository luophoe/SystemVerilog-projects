interface mem_int(input logic clk);
   timeunit 1ns;
   timeprecision 100ps;

   logic       read; 
   logic       write;
   logic [4:0] addr;
   logic [7:0] data_in;
   logic [7:0] data_out;

   modport master(output data_out, input clk, data_in, addr, read, write);
   modport slave(input data_out, clk, output data_in, addr, read, write, import read_mem, write_mem);

   // add read_mem and write_mem tasks
   task write_mem (
      input  [4:0] waddr,
      input  [7:0] wdata,
      input        debug = 0
      //output [4:0] addr,
      //output [7:0] data_in
   );
      @(negedge clk)
      read <= 1'b0;
      write <= 1'b1;
      data_in <= wdata;
      addr <= waddr;
      @(negedge clk) write <= 1'b0;

      if (debug)
         $display("Write addr: %b, Write data: %c", addr, data_in);
   endtask

   task read_mem (
      input  [4:0] raddr,
      input        debug = 0,
      output [7:0] rdata
   );
      @(negedge clk)
      addr <= raddr;
      write <= 1'b0;
      read <= 1'b1;
      @(negedge clk) read <= 1'b0;
      rdata = data_out;
      if (debug)
         $display("Read addr: %b, Read data: %c", addr, rdata);
   endtask


endinterface : mem_int
