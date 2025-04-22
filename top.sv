module top();
	import uvm_pkg::*;
	import test_pkg::*;

	bit clk;
always
#10 clk =~clk;

	ahb_if vif(clk);
	apb_if pvif(clk);
	
	rtl_top DUT(.Hclk(clk),
             .Hresetn(vif.Hresetn),
             .Htrans(vif.Htrans),
             .Hsize(vif.Hsize),
             .Hreadyin(vif.Hreadyin),
             .Hwdata(vif.Hwdata),
             .Haddr(vif.Haddr),
             .Hwrite(vif.Hwrite),
             .Hrdata(vif.Hrdata),
             .Hresp(vif.Hresp),
             .Hreadyout(vif.Hreadyout),
             .Pselx(pvif.Pselx),
             .Pwrite(pvif.Pwrite),
             .Penable(pvif.Penable),
             .Paddr(pvif.Paddr),
	     .Pwdata(pvif.Pwdata),
             .Prdata(pvif.Prdata));    

	initial
		begin
			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif
	uvm_config_db #(virtual ahb_if)::set(null,"*","vif",vif);
	uvm_config_db #(virtual apb_if)::set(null,"*","pvif",pvif);
	
	run_test();
	end
endmodule
