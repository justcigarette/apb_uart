class apb_driver extends uvm_driver #(apb_item);

    virtual apb_intf apb_intf;

    `uvm_component_utils(apb_driver)

    extern function new(string name = "apb_driver", uvm_component parent = null);

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

    extern task reset_signal();
    extern task write(apb_item apb_item);
    extern task read(apb_item apb_item);
    extern task drive_one(apb_item apb_item);

endclass

// constructor
function uart_tx_driver::new(string name="apb_driver", uvm_component parent);
  super.new(name, parent);
endfunction

// build phase
function void uart_tx_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db #(uart_config)::get(this, "", "tx_config", tx_config) || tx_config == null)
        `uvm_fatal("NOCFG", "uart_tx_driver: cannot get tx_config")
endfunction