class apb_driver extends uvm_driver;
`uvm_component_utils(apb_driver)
apb_agt_config m_cfg;
virtual apb_if.APB_DRV_MP pvif;
extern function new(string name ="apb_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut();
endclass

function apb_driver::new(string name ="apb_driver",uvm_component parent);
super.new(name,parent);
endfunction

function void apb_driver::build_phase(uvm_phase phase);
super.build_phase(phase);

	if(!uvm_config_db #(apb_agt_config)::get(this,"","apb_agt_config",m_cfg))
	`uvm_fatal("CONFIG","config doesn't set")

endfunction

////////////////connect phase////////////
function void apb_driver::connect_phase(uvm_phase phase);
	pvif=m_cfg.pvif;
endfunction

///////////////run phase //////////

task apb_driver::run_phase(uvm_phase phase);
	forever
		begin
		
			send_to_dut();
		end
endtask

//////////////////////////send to dut //////////////

task apb_driver::send_to_dut();
wait(pvif.apb_drv_cb.Pselx!=0)          //check setup state or not psel=1,penable=0 it is in setup state
	@(pvif.apb_drv_cb);
if(pvif.apb_drv_cb.Pwrite ==0)		
	pvif.apb_drv_cb.Prdata<=$random;		//driving pr data by checking pwrite==0
	@(pvif.apb_drv_cb);
//`uvm_info("APB_DRIVER",$sformatf("printing from monitor \n %s", xtn.sprint()),UVM_LOW)
endtask

