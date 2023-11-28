class monitor extends uvm_monitor;
    `uvm_component_utils(monitor) 

    uvm_analysis_port #(transaction) send;


    function new(string path = "monitor", uvm_component parent = null);
        super.new(path, parent);
        send = new("send", this);
    endfunction : new


    transaction t;
    virtual add_if aif;


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        t = transaction::type_id::create("t");

        if(!uvm_config_db #(virtual add_if)::get(this, "", "aif", aif)) begin 
            `uvm_error("MON", "Unable to access config_db")
        end
    endfunction : build_phase


    virtual task run_phase(uvm_phase phase);
        forever begin
            #10ns;
            t.a = aif.a;
            t.b = aif.b;
            t.y = aif.y; 
            `uvm_info("MON", $sformatf("Data send to scoreboard a : %0d, b : %0d, y : %0d", t.a, t.b, t.y), UVM_NONE)
            send.write(t);
        end
    endtask : run_phase
endclass : monitor