///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : counter.sv
// Title       : Simple class
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Simple counter class
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module counterclass;

// add counter class here    
class counter;
   int count;
   int max;
   int min;
   
   function new(input int data = 0, input int data_1, input int data_2);
      count = data;
      check_limit(data_1, data_2);
      check_set(data);
   endfunction

   function void check_limit(input int data_1, input int data_2);
      if (data_1 < data_2) begin
         max = data_2;
         min = data_1;
      end else begin
         max = data_1;
         min = data_2;
      end
   endfunction

   function void check_set(int set);
      if (set > max || set < min) begin
         count = min;
         $display("WARNING: set value is out of bound.");
      end else begin
         count = set;
      end
   endfunction

   function void load(input int data);
      check_set(data);
   endfunction

   function int get_count();
      return count;
   endfunction
endclass

class timer ():
   upcounter hours;
   upcounter minutes;
   upcounter seconds;

   function new(input int hr,  input int min, input int sec);
      hours = new(hr, 23, 0);
      minutes = new(min, 59, 0);
      seconds = new(sec, 59, 0);
   endfunction

   function void load(input int hr,  input int min, input int sec);
      hours.load(hr);
      minutes.load(min);
      seconds.load(sec);
   endfunction

   function void showval();
      $display("The current hour is %d, the current minute is %d, the current second is %d", hours.count, minutes.count, seconds.count);
   endfunction

   function void next();
      seconds.next();
      if (seconds.carry == 1) begin
         minutes.next();
         if (minutes.carry == 1)
            hours.next();
      end
      showval();
   endfunction 
      

class upcounter extends counter;
   bit carry;
   static int upcnt;
   function new(input int data, input int data_1, input int data_2);
      super.new(data, data_1, data_2);
      carry = 0;
      upcnt += 1;
   endfunction

   static function int get_cnt();
      return upcnt;
   endfunction

   function void next();
      count += 1;
      carry = 0;
      if (count >= max+1) begin
         count = min;
         carry = 1;
      end
      $display("The value is %d and the carry is %d", count, carry);
   endfunction
endclass

class downcounter extends counter;
   bit borrow;
   static int downcnt;
   function new(input int data, input int data_1, input int data_2);
      super.new(data, data_1, data_2);
      borrow = 0;
      downcnt += 1;
   endfunction

   static function int get_cnt();
      return downcnt;
   endfunction

   function void next();
      count -= 1;
      borrow = 0;
      if (count <= min-1) begin
         count = max;
         borrow = 1;
      end
      $display("The value is %d and the borrow is %d", count, borrow);
   endfunction
endclass



upcounter cnt1 = new(0, 0, 5);
downcounter cnt2 = new(10, 12, 8);

initial begin
   $display("The counter value is: %d", cnt1.get_count);
   cnt1.next();
   cnt1.next();
   cnt1.next();
   cnt1.next();
   cnt1.next();
   cnt1.next();
   cnt1.next();
   cnt1.next();
   $display("The counter value is: %d", cnt1.get_count);
   $display("The counter value is: %d", cnt2.get_count);
   cnt2.next();
   cnt2.next();
   cnt2.next();
   cnt2.next();
   cnt2.next();
   $display("The counter value is: %d", cnt2.get_count);
end

upcounter cnt3 = new(5, 10, 15);
downcounter cnt4 = new(14, 18, 8);
upcounter cnt5 = new(0, 0, 5);

initial begin
   $display("The number of upcounter is: %d", cnt5.get_cnt());
   $display("The number of downcounter is: %d", cnt4.get_cnt());
end

endmodule
