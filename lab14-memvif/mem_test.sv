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

   bit [7:0] rdata;

   virtual interface mem_int vir_intf;

   constraint dr1 {data_rand dist { [8'h41:8'h5a]:= 4, [8'h61:8'h7a] :=1};}

   function new(input int data_in, input int addr_in);
      data_rand = data_in;
      addr_rand = addr_in;
   endfunction

    // add read_mem and write_mem tasks
   task write_mem (input debug = 0);
      @(negedge vir_intf.clk)
      vir_intf.read <= 1'b0;
      vir_intf.write <= 1'b1;
      vir_intf.data_in <= data_rand;
      vir_intf.addr <= addr_rand;
      @(negedge vir_intf.clk) vir_intf.write <= 1'b0;

      if (debug)
         $display("Write addr: %b, Write data: %c", vir_intf.addr, vir_intf.data_in);
   endtask

   task read_mem (input debug = 0);
      @(negedge vir_intf.clk)
      vir_intf.addr <= addr_rand;
      vir_intf.write <= 1'b0;
      vir_intf.read <= 1'b1;
      @(negedge vir_intf.clk) vir_intf.read <= 1'b0;
      rdata = vir_intf.data_out;
      if (debug)
         $display("Read addr: %b, Read data: %c", vir_intf.addr, rdata);
   endtask

   function void configure( virtual interface mem_int vir_in);
      vir_intf = vir_in;
      if (vir_intf == null)
         $display("ERROR: input interface error");
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

  cls.configure(bus);

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
