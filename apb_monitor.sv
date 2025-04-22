class apb_monitor extends uvm_monitor;

  	`uvm_component_utils(apb_monitor)
	virtual apb_if.APB_MON_MP pvif;
          apb_agt_config m_cfg;
uvm_analysis_port #(apb_xtn) monitor_port;



	extern function new(string name = "apb_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();

endclass 
//-----------------  constructor new method  -------------------//
function apb_monitor::new(string name = "apb_monitor", uvm_component parent);
	super.new(name,parent);
 monitor_port=new("monitor_port",this);

endfunction

//-----------------  build() phase method  -------------------//
function void apb_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	  	if(!uvm_config_db #(apb_agt_config)::get(this,"","apb_agt_config",m_cfg))
			`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
endfunction

//-----------------  connect() phase method  -------------------//
function void apb_monitor::connect_phase(uvm_phase phase);
          pvif = m_cfg.pvif;
endfunction

//-----------------  run() phase method  -------------------//
task apb_monitor::run_phase(uvm_phase phase);
        forever
               collect_data();     
endtask


// ------------------------ collect data ----------------------//

task apb_monitor::collect_data();
       apb_xtn xtn;
	 xtn= apb_xtn::type_id::create("xtn");

/* while(pvif.apb_mon_cb.Pselx==0)    //check setup state or not and psel=1
	@(pvif.apb_mon_cb); */

wait(pvif.apb_mon_cb.Penable!=0)     // penable=1 itis in enable state
	@(pvif.apb_mon_cb);

		xtn.Paddr=pvif.apb_mon_cb.Paddr;
		xtn.Penable=pvif.apb_mon_cb.Penable;
		xtn.Pselx=pvif.apb_mon_cb.Pselx;
		xtn.Pwrite=pvif.apb_mon_cb.Pwrite;

if(xtn.Pwrite)
	xtn.Pwdata=pvif.apb_mon_cb.Pwdata;                  //pwite=1 then pwdata will sample
else
	xtn.Prdata=pvif.apb_mon_cb.Prdata;                  //pwrite=0 then prdata will sample

@(pvif.apb_mon_cb);
`uvm_info("APB_MONITOR",$sformatf("printing from monitor \n %s", xtn.sprint()),UVM_LOW) 


endtask

