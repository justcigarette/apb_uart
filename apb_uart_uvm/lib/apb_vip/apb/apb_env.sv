class apb_env extends uvm_env;
    `uvm_component_utils(apb_env)

    apb_agent agent;
    //apb_scoreboard scoreboard;
    //apb_coverage   coverage;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = apb_agent::type_id::create("agent", this);
        //scoreboard = apb_scoreboard::type_id::create("scoreboard", this);
        //coverage   = apb_coverage::type_id::create("coverage", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // agent.monitor.item_collected_port.connect(scoreboard.analysis_export);
        // agent.monitor.item_collected_port.connect(coverage.analysis_export);
    endfunction
    
endclass
