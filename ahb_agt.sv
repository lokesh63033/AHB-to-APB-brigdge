class ahb_agt extends uvm_agent;
`uvm_component_utils(ahb_agt)
ahb_agt_config m_cfg;

ahb_driver drvh;
ahb_monitor monh;
ahb_seqr seqrh;
extern function new(string name ="ahb_agt",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

function ahb_agt::new(string name ="ahb_agt",uvm_component parent);
super.new(name,parent);
endfunction

function void ahb_agt::build_phase(uvm_phase phase);
super.build_phase(phase);


 m_cfg=ahb_agt_config::type_id::create("m_cfg");

	if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",m_cfg))
	`uvm_fatal("CONFIG","config doesn't set")
                   // $display("ahb agent build_phase  getting data from agent top to agent",m_cfg.vif);
           
              
	monh=ahb_monitor::type_id::create("monh",this);
	
if(m_cfg.is_active == UVM_ACTIVE)
	begin
		drvh = ahb_driver::type_id::create("drvh",this);
		seqrh = ahb_seqr::type_id::create("seqrh",this);
	end
endfunction

function void ahb_agt::connect_phase(uvm_phase phase);
	if(m_cfg.is_active == UVM_ACTIVE)
		begin
		
	drvh.seq_item_port.connect(seqrh.seq_item_export);
		end
endfunction
