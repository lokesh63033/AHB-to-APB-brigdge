class ahb_agt_top extends uvm_agent;
`uvm_component_utils(ahb_agt_top)

	ahb_agt agth;
	env_config m_cfg;
extern function new(string name ="ahb_agt_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function ahb_agt_top::new(string name ="ahb_agt_top",uvm_component parent);
super.new(name,parent);
endfunction

function void ahb_agt_top::build_phase(uvm_phase phase);
super.build_phase(phase);


m_cfg=env_config::type_id::create("m_cfg");

	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
	`uvm_fatal("CONFIG","can't get the config")


 //$display("ahbtop build_phase  getting data from env to agent top @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",m_cfg.m_ahb_agt_cfg.vif);
                   // $display("env build_phase not getting data from test to env",m_cfg.m_ahb_agt_cfg.vif);*/





	uvm_config_db #(ahb_agt_config)::set(this,"agt*","ahb_agt_config",m_cfg.m_ahb_agt_cfg);
		agth=ahb_agt::type_id::create("agth",this);
endfunction

