class generator extends uvm_sequence #(transaction);
    `uvm_object_utils(generator)

    transaction t;
    integer i;

    function new(string path = "generator");
    endfunction : new


    virtual task body();
        t = transaction::type_id::create("t");
        repeat(10) begin
            start_item(t);
            t.randomize();
            `uvm_info("GEN", $sformatf("Data sent to Driver a : %0d b : %0d", t.a, t.b), UVM_NONE)
            finish_item(t);
        end
    endtask : body
endclass : generator