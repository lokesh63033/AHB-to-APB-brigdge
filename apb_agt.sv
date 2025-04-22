class apb_agt extends uvm_agent;
`uvm_component_utils(apb_agt)
apb_agt_config m_cfg;

apb_driver drvh;
apb_monitor monh;
apb_seqr seqrh;
extern function new(string name ="apb_agt",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function apb_agt::new(string name ="apb_agt",uvm_component parent);
super.new(name,parent);
endfunction

function void apb_agt::build_phase(uvm_phase phase);
super.build_phase(phase);

	if(!uvm_config_db #(apb_agt_config)::get(this,"","apb_agt_config",m_cfg))
	`uvm_fatal("CONFIG","config doesn't set")
	monh=apb_monitor::type_id::create("monh",this);
	
if(m_cfg.is_active ==UVM_ACTIVE)
	begin
		drvh = apb_driver::type_id::create("drvh",this);
		seqrh = apb_seqr::type_id::create("seqrh",this);
	end
endfunction

