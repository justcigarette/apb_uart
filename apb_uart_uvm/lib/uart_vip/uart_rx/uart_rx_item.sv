class uart_rx_item extends uvm_sequence_item;

    uart_config rx_config;

    rand bit[7:0] data_reg;

    bit parity_error;

    bit stop_error;

    `uvm_object_utils_begin(uart_rx_item)
        `uvm_field_int(data_reg, UVM_ALL_ON)
    `uvm_object_utils_end

    extern function new(string name="uart_rx_item");
endclass

//constructor
function uart_rx_item::new(string name="uart_rx_item");
    super.new(name);
endfunction