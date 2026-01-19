interface uart_tx_intf;
    logic clk;
    logic reset_n;
    logic tx;
    logic cts_n;

    //debug
    logic[7:0] data_in;

    modport driver_mp (
    input  cts_n,
    output tx
    );

endinterface