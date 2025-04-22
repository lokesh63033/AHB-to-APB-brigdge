class apb_agt_top extends uvm_agent;
`uvm_component_utils(apb_agt_top)

	apb_agt agth;
	env_config m_cfg;
extern function new(string name ="apb_agt_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function apb_agt_top::new(string name ="apb_agt_top",uvm_component parent);
super.new(name,parent);
endfunction

function void apb_agt_top::build_phase(uvm_phase phase);
super.build_phase(phase);

	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
	`uvm_fatal("CONFIG","can't get the config")

	uvm_config_db #(apb_agt_config)::set(this,"*","apb_agt_config",m_cfg.m_apb_agt_cfg);
		agth=apb_agt::type_id::create("agth",this);
endfunction


