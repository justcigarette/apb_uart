class apb_item extends uvm_sequence_item;
    rand bit        pwrite;
    rand bit [11:0] paddr;
    rand bit [3:0]  pstrb;
    rand bit [31:0] pwdata;

         bit        pslverr;
         bit [31:0] prdata;
         bit        pready;

    `uvm_object_utils_begin(apb_item);
        `uvm_field_int(pwrite  , UVM_ALL_ON)
        `uvm_field_int(paddr   , UVM_ALL_ON)
        `uvm_field_int(pstrb   , UVM_ALL_ON)
        `uvm_field_int(pready  , UVM_ALL_ON)
        `uvm_field_int(pwdata  , UVM_ALL_ON)
        `uvm_field_int(pslverr , UVM_NO_PACK)
        `uvm_field_int(prdata  , UVM_NO_PACK)
    `uvm_object_utils_end(apb_item)

    constraint default_addr{ paddr[1:0] == 2'b00; }

    constraint default_strb{ (pwrite == 1 && pstrb != 4'b0000); }

    extern function new(string name = "apb_item");
endclass

function new(string name ="apb_item");
    super.new(name);
endfunction