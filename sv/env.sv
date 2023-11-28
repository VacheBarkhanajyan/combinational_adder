class env extends uvm_env;
    `uvm_component_utils(env)


    function new(string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction : new


    scoreboard s;
    agent      a;


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        s = scoreboard::type_id::create("s", this);
        a = agent::type_id::create("a", this);
    endfunction : build_phase


    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        a.m.send.connect(s.recv);
    endfunction : connect_phase

endclass : env