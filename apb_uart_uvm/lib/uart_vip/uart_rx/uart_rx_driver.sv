class uart_rx_driver extends uvm_driver #(uart_rx_item);

    uart_config rx_config;

    virtual uart_rx_intf rx_intf;

    bit parity_bit;

    real bit_time;

    `uvm_component_utils(uart_rx_driver)

    extern function new(string name = "uart_rx_driver", uvm_component parent = null);

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

    extern task reset_signal();
    extern task receive(uart_rx_item rx_item);

endclass

// constructor
function uart_rx_driver::new(string name="dti_uart_tx_driver", uvm_component parent);
  super.new(name, parent);
endfunction

// build phase
function void uart_rx_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db #(uart_config)::get(this, "", "rx_config", rx_config) || rx_config == null)
        `uvm_fatal("NOCFG", "uart_rx_driver: cannot get rx_config")
endfunction

// connect phase
function void uart_rx_driver::connect_phase(uvm_phase phase);
    this.rx_intf = rx_config.rx_intf;
    if (rx_intf == null)
        `uvm_fatal("NOVIF", "uart_rx_driver: rx_intf is null in rx_config")
endfunction

// run phase
task uart_rx_driver::run_phase(uvm_phase phase);
    uart_tx_item rx_item = uart_rx_item::type_id::create("rx_item");

    @(negedge rx_intf.reset_n);
    reset_signal();
    wait(rx_intf.reset_n === 1'b1);

    bit_time = ((rx_config.frequency)/(rx_config.baudrate));
    `uvm_info("run_phase", $sformatf("baudrate = %0d bit_time = %0f", rx_config.baudrate, bit_time), UVM_DEBUG)

    forever begin
        seq_item_port.get_next_item(rx_item);
        receive(rx_item);
        seq_item_port.item_done();
    end
endtask

task uart_tx_driver::reset_signal();
    rx_intf.rts_n <= 1;
endtask

task uart_rx_driver::receive(uart_rx_item rx_item);
    
    parity_bit = 0;

    rx_intf.rts_n <= 0;

    // wait rx
    @(negedge rx_intf.rx);
    #(bit_time * 20ns);
    #(bit_time * 10ns);

    for(int i = 0; i < rx_config.data_bit_num + 5; i++) begin
        parity_bit = parity_bit ^ cur_item.data_reg;
        rx_intf.data_reg[i] <= rx_intf.rx;
        #(bit_time * 20ns);
    end

    if(rx_config.parity_bit_en == PARITY_EN) begin
        if(rx_config.parity_bit_type == PARITY_ODD) begin
            parity_bit = ~parity_bit
        end
        if(parity_bit != rx_intf.rx) begin
            rx_item.parity_error = 1;
        end
        #(bit_time * 20ns);
    end

    for(int i = 0; i < rx_config.stop_bit_num + 1; i++) begin
        #(bit_time * 20ns);
    end
endtask