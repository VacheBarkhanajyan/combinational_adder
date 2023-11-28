class test extends uvm_test;
    `uvm_component_utils(test)


    function new(string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction : new


    generator gen;
    env         e; 


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        gen = generator::type_id::create("gen");
        e   =       env::type_id::create("e", this);
    endfunction : build_phase


    virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
        gen.start(e.a.seqr);
    phase.drop_objection(this);
    
    endtask : run_phase
endclass : test