class ahb_seq extends uvm_sequence #(ahb_xtn);
	`uvm_object_utils(ahb_seq)
extern function new(string name = "ahb_seq");
endclass

function ahb_seq::new(string name ="ahb_seq");
super.new(name);
endfunction


////////////////////single///////////////////////
class single_seq extends ahb_seq;
	`uvm_object_utils(single_seq)
	bit[2:0]hsize;
	bit[31:0]haddr;
	bit hwrite;
	bit[9:0] hlength;
	bit[2:0] hburst;
	bit[1:0]htrans;
extern function new(string name = "single_seq");
extern task body();
endclass

function single_seq::new(string name ="single_seq");
	super.new(name);
endfunction

task single_seq::body();
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {Htrans == 2'b10 -> Hburst == 3'b000;});
	finish_item(req);
`uvm_info("AHB_SINGLE_SEQ",$sformatf("printing from seq \n %s",req.sprint()),UVM_LOW)

	end
endtask


///////////////increment//////////////////////

class incr_seq extends ahb_seq;
	`uvm_object_utils(incr_seq)
	bit[2:0]hsize;
	bit[31:0]haddr;
	bit hwrite;
	bit[9:0] hlength;
	bit[2:0] hburst;
	bit[1:0]htrans;
extern function new(string name = "incr_seq");
extern task body();
endclass

function incr_seq::new(string name ="incr_seq");
	super.new(name);
endfunction

task incr_seq::body();
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {Htrans == 2'b10;Hburst inside{1,3,5,7};});
	finish_item(req);
`uvm_info("AHB_INCR_SEQ",$sformatf("printing from seq \n %s",req.sprint()),UVM_LOW)
	hsize = req.Hsize;
	haddr = req.Haddr;
	hwrite = req.Hwrite;
	hlength = req.length;
	hburst = req.Hburst;
	htrans = req.Htrans;

	for(int i=1;i<hlength;i++)
		begin
	start_item(req);
		assert(req.randomize() with {Hburst == hburst;
					Hwrite == hwrite;
					Hsize == hsize;
					Haddr == haddr+(2**hsize);
					Htrans == 2'b11;});
	finish_item(req);
		haddr=req.Haddr;
	end 
	
	end

endtask

//////////////wrapping/////////////////////////
class wrap_seq extends ahb_seq;
	`uvm_object_utils(wrap_seq)
	
	bit[2:0]hsize;
	bit[31:0]haddr;
	bit hwrite;
	bit[1:0]htrans;
	bit[2:0]hburst;
	bit[9:0]hlength;
	bit[31:0]start_addr;
	bit[31:0]bound_addr;

extern function new(string name = "wrap_seq");
extern task body();
endclass
	

function wrap_seq ::new(string name ="wrap_seq");
super.new(name);
endfunction

task wrap_seq::body();
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {Htrans ==2'b10;Hburst inside {2,4,6};});
	finish_item(req);

`uvm_info("AHB_WRAP_SEQ",$sformatf("printing from seq \n %s",req.sprint()),UVM_LOW)
	hwrite = req.Hwrite;
	haddr = req.Haddr;
	hsize = req.Hsize;
	htrans =req.Htrans;
	hburst =req.Hburst;
	hlength = req.length;

	start_addr  =((haddr)/((2**hsize)*(hlength)))*((2**hsize)*(hlength));
	bound_addr =start_addr + ((2**hsize)*(hlength));
	
	haddr = req.Haddr+(2**hsize);
	for(int i=1;i<hlength;i++);
		begin
			if(haddr == bound_addr)
				haddr = start_addr;
	start_item(req);
		assert(req.randomize() with {Hsize ==hsize;
						Haddr == haddr;
						Hwrite == hwrite;
						Htrans == 2'b11;
						Hburst == hburst;});
	finish_item(req);
`uvm_info("AHB_WRAP_SEQ",$sformatf("printing from seq \n %s",req.sprint()),UVM_LOW)
	haddr = req.Haddr+(2**hsize);
	end
end
endtask
						
 	




