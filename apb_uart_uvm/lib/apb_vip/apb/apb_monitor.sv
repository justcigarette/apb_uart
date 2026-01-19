class apb_monitor extends uvm_monitor;
    `uvm_component_utils(apb_monitor)
    virtual apb_intf vif;
    uvm_analysis_port #(apb_item) item_collected_port;
    apb_item trans_collected;
    
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task collect_transaction();
endclass

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db#(virtual apb_intf)::get(this, "", "apb_intf", vif))
            `uvm_fatal(get_type_name(), "Virtual interface not found in config_db")
        item_collected_port = new("item_collected_port", this);
        trans_collected = apb_item::type_id::create("trans_collected");
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            wait(vif.reset_n);
            collect_transaction();
        end
    endtask
    
    task collect_transaction();
        apb_item item;
        @(posedge vif.clk);
        if(vif.psel && !vif.penable) begin
            item = apb_item::type_id::create("item");
            item.pwrite = vif.pwrite;
            item.paddr  = vif.paddr;
            item.pstrb  = vif.pstrb;
            
            if(vif.pwrite)
                item.pwdata = vif.pwdata;
            
            @(posedge vif.clk);
            while(!vif.pready) begin
                @(posedge vif.clk);
            end
            
            item.pready  = vif.pready;
            item.pslverr = vif.pslverr;
            if(!vif.pwrite)
                item.prdata = vif.prdata;
            item_collected_port.write(item);
            `uvm_info(get_type_name(), $sformatf("Transaction collected:\n%s", item.sprint()), UVM_MEDIUM)
        end
    endtask
    
