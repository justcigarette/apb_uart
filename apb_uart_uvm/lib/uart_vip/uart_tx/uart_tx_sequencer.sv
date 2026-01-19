class uart_tx_sequencer extends uvm_sequencer #(uart_tx_item);

    `uvm_component_utils(uart_tx_sequencer)
    
    extern function new(string name = "uart_tx_sequencer", uvm_component parent = null);
endclass

//constructor
function uart_tx_sequencer::new(string name = "uart_tx_sequencer", uvm_component parent = null);
    super.new(name, parent);
endfunction