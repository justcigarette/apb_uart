class uart_config extends uvm_object;

    // tx interface
    virtual uart_tx_intf tx_intf;

    // rx interface
    virtual uart_rx_intf rx_intf;

    //frenquency 50MHz
    int frequency = 50_000_000;

    //baudrate
    int baudrate = UART_BAUDRATE_115200;

    //data bit num
    data_bit_num_cfg data_bit_num = DATA_8_BIT;

    //parity bit en
    parity_bit_en_cfg parity_bit_en = PARITY_EN;

    //parity bit type
    parity_bit_type_cfg parity_bit_type = PARITY_EVEN;

    //stop bit num
    stop_bit_num_cfg stop_bit_num = STOP_1_BIT;

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    `uvm_object_utils_begin(uart_config)
        `uvm_field_enum (data_bit_num_cfg,    is_active, UVM_ALL_ON)
        `uvm_field_enum (parity_bit_en_cfg,   is_active, UVM_ALL_ON)
        `uvm_field_enum (parity_bit_type_cfg, is_active, UVM_ALL_ON)
        `uvm_field_enum (stop_bit_num,        is_active, UVM_ALL_ON)
    `uvm_object_utils_end

    extern function new(string name="uart_config");

endclass

//constructor
function uart_config::new(string nam="uart_config");
    super.new(name);
endfunction