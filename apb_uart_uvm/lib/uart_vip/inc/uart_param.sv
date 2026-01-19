//data bit num
`define UART_DATA_BIT_NUM_5 5
`define UART_DATA_BIT_NUM_5 6
`define UART_DATA_BIT_NUM_5 7
`define UART_DATA_BIT_NUM_5 8 

//baudrate
`define UART_BAUDRATE_300    300
`define UART_BAUDRATE_600    600
`define UART_BAUDRATE_1200   1200
`define UART_BAUDRATE_2400   2400
`define UART_BAUDRATE_4800   4800
`define UART_BAUDRATE_9600   9600
`define UART_BAUDRATE_19200  19200
`define UART_BAUDRATE_38400  38400
`define UART_BAUDRATE_56000  56000
`define UART_BAUDRATE_57600  57600
`define UART_BAUDRATE_115200 115200
`define UART_BAUDRATE_128000 128000
`define UART_BAUDRATE_153600 153600
`define UART_BAUDRATE_230400 230400

//stop bit
`define STOP_BIT_NUM_1 1
`define STOP_BIT_NUM_2 2

typedef enum bit[1:0] {
    DATA_5_BIT = 2'b00,
    DATA_6_BIT = 2'b01,
    DATA_7_BIT = 2'b10,
    DATA_8_BIT = 2'b11
} data_bit_num_cfg;

typedef enum bit {
    PARITY_DIS = 0,
    PARITY_EN  = 1
} parity_bit_en_cfg;

typedef enum bit {
    PARITY_EVEN = 0,
    PARITY_ODD  = 1
} parity_bit_type_cfg;

typedef enum bit {
    STOP_1_BIT = 0,
    STOP_2_BIT = 1
} stop_bit_num_cfg;