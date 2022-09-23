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

class randclass;
   rand bit    [7:0] data_rand;
   randc bit   [4:0] addr_rand;

   constraint dr1 {data_rand dist { [8'h41:8'h5a]:= 4, [8'h61:8'h7a] :=1};}

   function new(input int data_in, input int addr_in);
      data_rand = data_in;
      addr_rand = addr_in;
   endfunction

endclass

// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

randclass cls = new (0, 0);

initial
  begin: memtest
  int error_status;
  error_status = 0;

    $display("Clear Memory Test");

    for (int i = 0; i< 32; i++)
       // Write zero data to every address location
       bus.write_mem(.waddr(i), .wdata(0), .debug(0));
       
    for (int i = 0; i<32; i++)
      begin 
       // Read every address location
         bus.read_mem(.raddr(i), .debug(0), .rdata(rdata));
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
       bus.write_mem(.waddr(i), .wdata(i), .debug(0));
    for (int i = 0; i<32; i++)
      begin
       // Read every address location
       bus.read_mem(.raddr(i), .debug(0), .rdata(rdata));
       // check each memory location for data = address
       if(rdata != i)
            $display("Data: %d", rdata);
            error_status += 1;
      end

   // print results of test
      printstatus(error_status);

     $display("Data = Random Data");

    for (int i = 0; i< 32; i++) begin
       data_out = cls.randomize();
       // Write random data to every address location
       bus.write_mem(.waddr(cls.addr_rand), .wdata(cls.data_rand), .debug(1));
       // Read every address location
       bus.read_mem(.raddr(cls.addr_rand), .debug(1), .rdata(rdata));
       // check each memory location for data = random data
       if(rdata != cls.data_rand)
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
