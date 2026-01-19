interface uart_tx_intf;
    logic clk;
    logic reset_n;
    logic rx;
    logic rts_n;

    //debug
    logic[7:0] data_in;

    modport driver_mp (
    output rts_n,
    input  rx
    );

endinterface