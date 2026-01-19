class apb_driver extends uvm_driver #(apb_item);
    `uvm_component_utils(apb_driver)

    virtual apb_intf vif;
    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern task reset_signal();
    extern task write(apb_item apb_item);
    extern task read(apb_item apb_item);
    extern task select_drive(apb_item apb_item);

endclass

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_intf)::get(this, "", "apb_intf", vif))
        `uvm_fatal(get_type_name(), "Virtual interface not found in config_db")
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction

task run_phase(uvm_phase phase);
    forever begin
        wait(vif.reset_n);
        seq_item_port.get_next_item(req);
        select_drive(req);
        seq_item_port.item_done();
    end
endtask

task reset_signal();
    vif.psel    <= 1'b0;
    vif.penable <= 1'b0;
    vif.pwrite  <= 1'b0;
    vif.paddr   <= 12'h0;
    vif.pstrb   <= 4'h0;
    vif.pwdata  <= 32'h0;
endtask

task write(apb_item apb_item);
    @(posedge vif.clk);
    vif.psel    <= 1'b1;
    vif.penable <= 1'b0;
    vif.pwrite  <= 1'b1;
    vif.paddr   <= apb_item.paddr;
    vif.pwdata  <= apb_item.pwdata;
    vif.pstrb   <= apb_item.pstrb;
    
    @(posedge vif.clk);
    vif.penable <= 1'b1;
    
    while(!vif.pready) begin
        @(posedge vif.clk);
    end
    apb_item.pslverr = vif.pslverr;
    
    @(posedge vif.clk);
    vif.psel    <= 1'b0;
    vif.penable <= 1'b0;
    vif.pwrite  <= 1'b0;
    vif.pstrb   <= 4'h0;
endtask

task read(apb_item apb_item);
    @(posedge vif.clk);
    vif.psel    <= 1'b1;
    vif.penable <= 1'b0;
    vif.pwrite  <= 1'b0;
    vif.paddr   <= apb_item.paddr;
    vif.pstrb   <= 4'h0;  
    
    @(posedge vif.clk);
    vif.penable <= 1'b1;
    
    while(!vif.pready) begin
        @(posedge vif.clk);
    end
    
    apb_item.prdata  = vif.prdata;
    apb_item.pslverr = vif.pslverr;
    
    @(posedge vif.clk);
    vif.psel    <= 1'b0;
    vif.penable <= 1'b0;
endtask

task select_drive(apb_item apb_item);
    if(apb_item.pwrite)
        write(apb_item);
    else
        read(apb_item);
endtask