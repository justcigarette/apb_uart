class uart_tx_agent extends uvm_agent;

    `uvm_component_utils(uart_tx_agent);

    uart_config tx_config;

    uart_tx_driver tx_driver;

    uart_tx_monitor tx_monitor;

    uart_tx_sequencer tx_sequencer;

    extern function new(string name="uart_tx_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass

function uart_tx_agent::new(string name="uart_tx_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction

function uart_tx_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //get config
    if(!uvm_config_db #(uart_config)::get(this, "", "tx_config", tx_config) || tx_config == null)
        `uvm_fatal("NOCFG", "uart_tx_agent: cannot get tx_config")
    
    //set config
    uvm_config_db #(uart_config)::set(this, "*", "tx_config", tx_config);

    //create component
    tx_monitor = uart_tx_monitor::type_id::create("tx_monitor", this);

    if (tx_config.is_active == UVM_ACTIVE) begin
        tx_sequencer = uart_tx_sequencer::type_id::create("tx_sequencer", this);
        tx_driver = uart_tx_driver::type_id::create("tx_driver", this);
    end
endfunction

function uart_tx_agent::connect_phase(uvm_phase phase);
    tx_monitor.tx_config = tx_config;
    if (tx_config.is_active == UVM_ACTIVE) begin
        tx_driver.seq_item_port.connect(sequencer.seq_item_export);
        tx_sequencer.tx_config = tx_config;
        tx_driver._tx_config = tx_config;
    end
endfunction