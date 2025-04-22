interface ahb_if(input bit clk);
	logic Hresetn;
	logic [31:0] Haddr;
	logic [1:0] Htrans,Hresp;
	logic Hwrite,Hready;
	logic [2:0] Hsize;
	logic [2:0] Hburst;
	logic [31:0] Hwdata,Hrdata;
	logic Hreadyin,Hreadyout;

//AHB driver

clocking ahb_drv_cb@(posedge clk);
	default input#1 output #1;

	output Hresetn;
	output Htrans;
	output Hwrite;
	output Hwdata;
	output Haddr;
	output Hreadyin;
	output Hburst;
	output Hsize;

	input Hrdata;
	input Hreadyout;

endclocking

//AHB monitor

clocking ahb_mon_cb@(posedge clk);
	default input#1 output #1;

	input Hresetn;
	input Htrans;
	input Hwrite;
	input Hwdata;
	input Haddr;
	input Hreadyin;
	input Hburst;
	input Hsize;

	input Hrdata;
	input Hreadyout;

endclocking
	
		
//AHB driver MP
modport AHB_DRV_MP(clocking ahb_drv_cb);
//AHB monitor MP
modport AHB_MON_MP(clocking ahb_mon_cb);

endinterface	

