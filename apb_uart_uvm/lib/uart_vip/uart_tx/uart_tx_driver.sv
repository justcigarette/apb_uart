class uart_tx_driver extends uvm_driver #(uart_tx_item);

    uart_config tx_config;

    virtual uart_tx_intf tx_intf;

    bit parity_bit;

    real bit_time;

    `uvm_component_utils(uart_tx_driver)

    extern function new(string name = "uart_tx_driver", uvm_component parent = null);

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

    extern task reset_signal();
    extern task transmit(uart_tx_item tx_item);

endclass

// constructor
function uart_tx_driver::new(string name="dti_uart_tx_driver", uvm_component parent);
  super.new(name, parent);
endfunction

// build phase
function void uart_tx_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db #(uart_config)::get(this, "", "tx_config", tx_config) || tx_config == null)
        `uvm_fatal("NOCFG", "uart_tx_driver: cannot get tx_config")
endfunction

// connect phase
function void uart_tx_driver::connect_phase(uvm_phase phase);
    this.tx_intf = tx_config.tx_intf;
    if (tx_intf == null)
        `uvm_fatal("NOVIF", "uart_tx_driver: tx_intf is null in tx_config")
endfunction

// run phase
task uart_tx_driver::run_phase(uvm_phase phase);
    uart_tx_item tx_item;

    @(negedge tx_intf.reset_n);
    reset_signal();
    wait(tx_intf.reset_n === 1'b1);

    bit_time = ((tx_config.frequency)/(tx_config.baudrate));
    `uvm_info("run_phase", $sformatf("baudrate = %0d bit_time = %0f", tx_config.baudrate, bit_time), UVM_DEBUG)

    forever begin
        seq_item_port.get_next_item(tx_item);
        transmit(tx_item);
        seq_item_port.item_done();
    end
endtask

task uart_tx_driver::reset_signal();
    tx_intf.reset_n <= 0;
    tx_intf.tx      <= 1;
endtask

task uart_tx_driver::transmit(uart_tx_item tx_item);
    // current item
    uart_tx_item cur_tx_item = uart_tx_item::type_id::create("cur_tx_item");
    cur_tx_item.copy(tx_item);
    parity_bit = 0;

    // wait rx
    wait(tx_intf.cts_n == 0);
    @(posedge tx_intf.clk);
    tx_intf.tx <= 1'b0;
    tx_intf.data_in = cur_tx_item.data_in;
    #(bit_time * 20ns);

    for(int i = 0; i < tx_config.data_bit_num + 5; i++) begin
        parity_bit = parity_bit ^ cur_item.data_in;
        tx_intf.tx <= cur_tx_item.data_in[i];
        #(bit_time * 20ns);
    end

    if(tx_config.parity_bit_en == PARITY_EN) begin
        if(tx_config.parity_bit_type == PARITY_ODD) begin
            parity_bit = ~parity_bit
        end
        tx_intf.tx <= parity_bit;
        #(bit_time * 20ns);
    end

    if(tx_config.stop_bit_num == STOP_2_BIT) begin
        for(int i = 0; i < STOP_BIT_NUM_2; i++) begin
            tx_intf.tx <= 1;
            #(bit_time * 20ns);
        end
    end
    else begin
        tx_intf.tx <= 1;
        #(bit_time * 20ns);
    end
endtask

