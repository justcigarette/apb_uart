interface apb_intf;
    logic        clk;
    logic        reset_n;
    logic        pready;
    logic        pslverr;
    logic [31:0] prdata;
    logic        psel;
    logic        penable;
    logic        pwrite;
    logic [11:0] paddr;
    logic [3:0]  psrtb;
    logic [31:0] pwdata;

    modport driver_mp (
    input  clk,
    input  reset_n,
    input  pready,
    input  pslverr,
    input  prdata,
    output psel,
    output penable,
    output pwrite,
    output paddr,
    output psrtb,
    output pwdata
    );

endinterface