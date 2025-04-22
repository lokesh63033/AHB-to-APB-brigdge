class env_config extends uvm_object;
`uvm_object_utils(env_config)
bit  has_functional_coverage=1;
bit  has_ahb_agt;
bit  has_apb_agt;
bit  has_scoreboard=1;

ahb_agt_config m_ahb_agt_cfg;
apb_agt_config m_apb_agt_cfg;

bit no_of_ahb_agt=1;
bit no_of_apb_agt=1;

extern function new(string name ="env_config");
endclass

function env_config::new(string name ="env_config");
super.new(name);
endfunction
