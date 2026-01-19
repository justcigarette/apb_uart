class uart_rx_monitor extends uvm_monitor;

    `uvm_component_utils(uart_rx_monitor);

    uart_config rx_config;

    virtual uart_rx_interface rx_intf;

    uvm_analysis_port #(uart_rx_item) ap;

    real bit_time;

    extern function new(string name = "uart_rx_monitor", uvm_component parent);
    extern virual function void build_phase(uvm_phase phase);
    extern virual function void connect_phase(uvm_phase phase);
    extern virual task run_phase(uvm_phase phase);
endclass

function uart_rx_monitor::new(string name = "uart_rx_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
endfunction

function void uart_rx_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual uart_rx_interface)::get(this, "", "rx_intf", rx_intf))
        `uvm_fatal("TX_MON", "Cannot get rx_intf");

    if(!uvm_config_db#(uart_config)::get(this, "", "rx_config", rx_config))
        `uvm_fatal("TX_MON", "Cannot get rx_config");
endfunction

function void uart_rx_monitor::connect_phase(uvm_phase phase);
    this.rx_intf = rx_config.rx_intf;
    if (rx_intf == null)
        `uvm_fatal("NOVIF", "uart_tx_driver: rx_intf is null in rx_config")
endfunction

task uart_rx_monitor::run_phase(uvm_phase phase);
    bit_time = ((rx_config.frequency)/(rx_config.baudrate));

    forever begin
    uart_rx_item rx_item = uart_rx_item::type_id::create("rx_item");

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
            `uvm_error("RX_ERROR", "Parity bit fail")
        end
        #(bit_time * 20ns);
    end

    for(int i = 0; i < rx_config.stop_bit_num + 1; i++) begin
        if(rx_intf.rx != 1) begin
            rx_item.stop_error = 1;
            if(i == 0)
                `uvm_error("RX_ERROR", "Stop bit 1 fail")
            else
                `uvm_error("RX_ERROR", "Stop bit 2 fail")
        end
        #(bit_time * 20ns);
    end    

    out_monitor_port.write(rx_item);
    end
endtask