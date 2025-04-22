interface apb_if(input bit clk);
	logic Penable;
	logic Pwrite;
	logic [31:0] Paddr;
	logic [31:0]Pwdata,Prdata;
	logic [3:0]Pselx;

//APB driver
	
clocking apb_drv_cb@(posedge clk);
	default input#1 output #1;

	output Prdata;
	input Penable;
	input Pwrite;
	input Pselx;
	input Pwdata;
	
endclocking

//APB monitor

clocking apb_mon_cb@(posedge clk);
	default input#1 output #1;

	input Prdata;
	input Penable;
	input Pwrite;
	input Pselx;
	input Pwdata;
	input Paddr;
endclocking

//APB driver MP
modport APB_DRV_MP(clocking apb_drv_cb);
//APB monitor MP
modport APB_MON_MP(clocking apb_mon_cb);

endinterface		

