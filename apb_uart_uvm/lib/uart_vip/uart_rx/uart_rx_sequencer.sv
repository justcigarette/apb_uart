class uart_rx_sequencer extends uvm_sequencer #(uart_tx_item);

    `uvm_component_utils(uart_rx_sequencer)
    
    extern function new(string name = "uart_rx_sequencer", uvm_component parent = null);
endclass

//constructor
function uart_rx_sequencer::new(string name = "uart_rx_sequencer", uvm_component parent = null);
    super.new(name, parent);
endfunction