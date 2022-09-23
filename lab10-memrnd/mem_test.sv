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

module mem_test (mem_int.slave     bus);
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking
logic [7:0] data;       // stores data for randomize variable
bit         data_out;   // stores output from randomization

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
       bus.write_mem(.waddr(i), .wdata(0), .debug(1));
       
    for (int i = 0; i<32; i++)
      begin 
       // Read every address location
         bus.read_mem(.raddr(i), .debug(1), .rdata(rdata));
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
       bus.write_mem(.waddr(i), .wdata(i), .debug(1));
    for (int i = 0; i<32; i++)
      begin
       // Read every address location
       bus.read_mem(.raddr(i), .debug(1), .rdata(rdata));
       // check each memory location for data = address
       if(rdata != i)
            $display("Data: %d", rdata);
            error_status += 1;
      end

   // print results of test
      printstatus(error_status);

     $display("Data = Random Data");

    for (int i = 0; i< 32; i++) begin
       data_out = randomize(data) with {data dist {[8'h41:8'h5a]:=8, [8'h61:8'h7a]:=2};};
       // Write random data to every address location
       bus.write_mem(.waddr(i), .wdata(data), .debug(1));
       // Read every address location
       bus.read_mem(.raddr(i), .debug(1), .rdata(rdata));
       // check each memory location for data = random data
       if(rdata != data)
            $display("Data: %d", rdata);
            error_status += 1;
    end

   // print results of test
      printstatus(error_status);

    $finish;

   end

// add result print function
   function void printstatus (input status);
      if (status == 0)
         $display("Test passed.");
      else
         $display("Test failed. Error Number: %d", status);
   endfunction


endmodule
