class uart_rx_sequence extends uvm_sequence#(uart_rx_item);
    
    `uvm_object_utils(uart_rx_sequence)
    
    `uvm_declare_p_sequencer(uart_rx_sequencer)

    uart_config uart_rx_config

    rand bit[7:0] data_reg;

    extern function new(string name="uart_rx_sequence");
    extern virtual task body();

endclass

//constructor
function uart_rx_sequence::new(string name ="uart_rx_sequence")
    super.new(name);
endfunction

function void pre_randomize();
    if (uart_rx_config == null)
        uart_rx_config = p_sequencer.uart_rx_config;
endfunction

task uart_rx_sequence::body();
    rx_item = uart_rx_item::type_id::create("rx_item");
    `uvm_do_with(rx_item, {data_reg == local::data_reg;})
    `uvm_info(get_type_name(), $sformatf("UART_TX item data=0x%02h", rx_item.data_reg), UVM_LOW)
endtask