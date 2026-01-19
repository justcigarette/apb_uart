class uart_tx_sequence extends uvm_sequence#(uart_tx_item);
    
    `uvm_object_utils(uart_tx_sequence)
    
    `uvm_declare_p_sequencer(uart_tx_sequencer)

    uart_config uart_tx_config

    rand bit[7:0] data_in;

    extern function new(string name="uart_tx_sequence");
    extern virtual task body();

endclass

//constructor
function uart_tx_sequence::new(string name ="uart_tx_sequence")
    super.new(name);
endfunction

function void pre_randomize();
    if (uart_tx_config == null)
        uart_tx_config = p_sequencer.uart_tx_config;
endfunction

task uart_tx_sequence::body();
    tx_item = uart_tx_item::type_id::create("tx_item");
    `uvm_do_with(tx_item, {data_in == local::data_in;})
    `uvm_info(get_type_name(), $sformatf("UART_TX item data=0x%02h", tx_item.data_in), UVM_LOW)
endtask