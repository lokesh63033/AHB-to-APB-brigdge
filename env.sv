 class env extends uvm_env;
`uvm_component_utils(env);

	ahb_agt_top ahbagt_top;
	apb_agt_top apbagt_top;
	scoreboard sb;
	env_config m_cfg;

extern function new(string name = "env",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

function env::new(string name ="env",uvm_component parent);
super.new(name,parent);
endfunction

function void env::build_phase(uvm_phase phase);
super.build_phase(phase);

//m_cfg=env_config::type_id::create("m_cfg");


	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
	`uvm_fatal("","you didn't set the config")
                    //$display("env build_phase not getting data from test to env  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",m_cfg);
   
              

ahbagt_top =ahb_agt_top::type_id::create("ahbagt_top",this);
apbagt_top=apb_agt_top::type_id::create("apbagt_top",this);

	if(m_cfg.has_scoreboard)
		sb=scoreboard::type_id::create("sb",this);

endfunction

function void env::connect_phase(uvm_phase phase);
	if(m_cfg.has_scoreboard)
		begin
			ahbagt_top.agth.monh.monitor_port.connect(sb.ahb_fifo.analysis_export);

			apbagt_top.agth.monh.monitor_port.connect(sb.apb_fifo.analysis_export);

		end
endfunction
