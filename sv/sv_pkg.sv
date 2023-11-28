package sv_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    typedef class transaction;
    typedef class   generator;
    typedef class      driver;
    typedef class     monitor;
    typedef class  scoreboard;
    typedef class       agent;
    typedef class         env;
    typedef class        test;

    `include "transaction.sv"
    `include "generator.sv"
    `include "driver.sv"
    `include "monitor.sv"
    `include "scoreboard.sv"
    `include "agent.sv"
    `include "env.sv"
    `include "test.sv"
endpackage : sv_pkg