class driver extends uvm_driver #(transaction);
    `uvm_component_utils(driver)

    function new(string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction : new


    transaction tc;
    virtual add_if aif;


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tc = transaction::type_id::create("tc");

        if(!uvm_config_db #(virtual add_if)::get(this, "", "aif", aif)) begin
            `uvm_error("DRV", "Unable to access config_db")
        end

    endfunction : build_phase


    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(tc);
            aif.a <= tc.a;
            aif.b <= tc.b;
            seq_item_port.item_done();
            #10ns;
        end
    endtask : run_phase

endclass : driver