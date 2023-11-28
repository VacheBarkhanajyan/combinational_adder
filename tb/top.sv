`include "uvm_macros.svh"
import uvm_pkg::*;

import sv_pkg::*;

module top();

    add_if aif();
    add dut (
        .a(aif.a),
        .b(aif.b),
        .y(aif.y)
          );

   


    initial begin
        uvm_config_db #(virtual add_if)::set(null, "uvm_test_top.e.a*", "aif", aif);
        run_test("test");
    end
endmodule : top