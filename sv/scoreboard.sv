class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    uvm_analysis_imp #(transaction, scoreboard) recv;

    transaction tr;


    function new(string path = "scoreboard", uvm_component parent = null);
        super.new(path, parent);
        recv = new("read", this);
    endfunction : new


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
    endfunction : build_phase


    virtual function void write(input transaction t);
        tr = t;
        `uvm_info("SCO", $sformatf("Data receved from Monitor a : %0d b : %0d y : %0d", tr.a, tr.b, tr.y), UVM_NONE)
        if(tr.y == tr.a + tr.b) begin
            `uvm_info("SCO", "TEST PASSED", UVM_NONE)
        end else begin
            `uvm_info("SCO", "TEST FAILED", UVM_NONE)
        end
    endfunction : write
endclass : scoreboard