class uart_rx_agent extends uvm_agent;

    `uvm_component_utils(uart_rx_agent);

    uart_config rx_config;

    uart_rx_driver rx_driver;

    uart_rx_monitor rx_monitor;

    uart_rx_sequencer rx_sequencer;

    extern function new(string name="uart_rx_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass

function uart_rx_agent::new(string name="uart_rx_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction

function uart_rx_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //get config
    if(!uvm_config_db #(uart_config)::get(this, "", "rx_config", rx_config) || rx_config == null)
        `uvm_fatal("NOCFG", "uart_rx_agent: cannot get rx_config")
    
    //set config
    uvm_config_db #(uart_config)::set(this, "*", "rx_config", rx_config);

    //create component
    rx_monitor = uart_rx_monitor::type_id::create("rx_monitor", this);

    if (rx_config.is_active == UVM_ACTIVE) begin
        rx_sequencer = uart_rx_sequencer::type_id::create("rx_sequencer", this);
        rx_driver = uart_rx_driver::type_id::create("rx_driver", this);
    end
endfunction

function uart_rx_agent::connect_phase(uvm_phase phase);
    rx_monitor.rx_config = rx_config;
    if (rx_config.is_active == UVM_ACTIVE) begin
        rx_driver.seq_item_port.connect(sequencer.seq_item_export);
        rx_sequencer.rx_config = rx_config;
        rx_driver._tx_config = rx_config;
    end
endfunction