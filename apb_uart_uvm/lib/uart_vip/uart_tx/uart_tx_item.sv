class uart_tx_item extends uvm_sequence_item;

    uart_config tx_config;

    rand bit[7:0] data_in;

    `uvm_object_utils_begin(uart_tx_item)
        `uvm_field_int(data_in, UVM_ALL_ON)
    `uvm_object_utils_end

    //constraint data in
    constraint c_mask_data_bit{
        if(tx_config != null){
            if(tx_config.data_bit_num == DATA_5_BIT)      data_in[7:5] == '0;
            else if(tx_config.data_bit_num == DATA_6_BIT) data_in[7:6] == '0;
            else if(tx_config.data_bit_num == DATA_7_BIT) data_in[7]   == '0;
        }
    }

    extern function new(string name="uart_tx_item");
endclass

//constructor
function uart_tx_item::new(string name="uart_tx_item");
    super.new(name);
endfunction