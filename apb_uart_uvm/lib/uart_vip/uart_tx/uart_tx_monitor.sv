class uart_tx_monitor extends uvm_monitor;

    `uvm_component_utils(uart_tx_monitor);

    uart_config tx_config;

    virtual uart_tx_interface tx_intf;

    uvm_analysis_port #(uart_tx_item) ap;

    real bit_time;

    extern function new(string name = "uart_tx_monitor", uvm_component parent);
    extern virual function void build_phase(uvm_phase phase);
    extern virual function void connect_phase(uvm_phase phase);
    extern virual task run_phase(uvm_phase phase);
endclass

function uart_tx_monitor::new(string name = "uart_tx_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
endfunction

function void uart_tx_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual uart_tx_interface)::get(this, "", "tx_intf", tx_intf))
        `uvm_fatal("TX_MON", "Cannot get tx_intf");

    if(!uvm_config_db#(uart_config)::get(this, "", "tx_config", tx_config))
        `uvm_fatal("TX_MON", "Cannot get tx_config");
endfunction

function void uart_tx_monitor::connect_phase(uvm_phase phase);
    this.tx_intf = tx_config.tx_intf;
    if (tx_intf == null)
        `uvm_fatal("NOVIF", "uart_tx_driver: tx_intf is null in tx_config")
endfunction

task uart_tx_monitor::run_phase(uvm_phase phase);
    bit_time = ((tx_config.frequency)/(tx_config.baudrate));

    forever begin
      uart_tx_item tx_item = uart_tx_item::type_id::create("tx_item");
      @(negedge tx_intf.tx);
      tx_item.data_in = '0;
      #(bit_time*10ns);
      #(bit_time*20ns);
      
      for(int i = 0; i < tx_config.data_bit_num + 5; i++) begin
        tx_item.data_in[i] = tx_intf.tx;
        #(bit_time*20ns);
      end

      out_monitor_port.write(tx_item);
    end
endtask