///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Memory testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module mem_test ( input logic clk, 
                  output logic read, 
                  output logic write, 
                  output logic [4:0] addr, 
                  output logic [7:0] data_in,     // data TO memory
                  input  wire [7:0] data_out     // data FROM memory
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking

// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

initial
  begin: memtest
  int error_status;
  error_status = 0;

    $display("Clear Memory Test");

    for (int i = 0; i< 32; i++)
       // Write zero data to every address location
       write_mem(.waddr(i), .wdata(0), .debug(1));
       
    for (int i = 0; i<32; i++)
      begin 
       // Read every address location
         read_mem(.raddr(i), .debug(1), .rdata(rdata));
       // check each memory location for data = 'h00
         if(rdata != 'h00)
            $display("Data: %d", rdata);
            error_status += 1;
      end

   // print results of test
      printstatus(error_status);

    $display("Data = Address Test");

    for (int i = 0; i< 32; i++)
       // Write data = address to every address location
       write_mem(.waddr(i), .wdata(i), .debug(1));
    for (int i = 0; i<32; i++)
      begin
       // Read every address location
       read_mem(.raddr(i), .debug(1), .rdata(rdata));
       // check each memory location for data = address
       if(rdata != i)
            $display("Data: %d", rdata);
            error_status += 1;
      end

   // print results of test
      printstatus(error_status);


    $finish;
  end

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
         $display("Write addr: %b, Write data: %b", addr, data_in);
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
         $display("Read addr: %b, Read data: %b", addr, rdata);
   endtask

// add result print function
   function void printstatus (input status);
      if (status == 0)
         $display("Test passed.");
      else
         $display("Test failed. Error Number: %d", status);
   endfunction


endmodule
