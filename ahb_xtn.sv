 class ahb_xtn extends uvm_sequence_item;
  
    	`uvm_object_utils(ahb_xtn)
rand bit [31:0] Haddr;
rand bit [31:0] Hwdata;
bit [31:0] Hrdata;
rand bit [2:0] Hburst;
rand bit [1:0] Htrans;
rand bit [2:0] Hsize;
rand bit Hwrite;
rand bit [9:0] length;
bit  Hresetn,Hreadyin,Hreadyout,Hclk;
bit [1:0] Hresp;

constraint c1{Hsize inside {0,1,2};}

constraint valid_haddr{Haddr inside {[32'h8000_0000 : 32'h8000_03ff],
			             [32'h8400_0000 : 32'h8400_03ff],
			             [32'h8800_0000 : 32'h8800_03ff],
			             [32'h8c00_0000 : 32'h8c00_03ff]};}

constraint valid_hsize{Hsize==1 -> Haddr%2==0;
	               Hsize==2 -> Haddr%4==0;}

constraint valid_range{ Haddr%1024+(length*(2**Hsize)<=1023);}
constraint c2{Hburst==3'd2 -> length==4;}
constraint c3{Hburst==3'd3 -> length==4;}
constraint c4{Hburst==3'd4 -> length==8;}
constraint c5{Hburst==3'd5 -> length==8;}
constraint c6{Hburst==3'd6 -> length==16;}
constraint c7{Hburst==3'd7 -> length==16;}

extern function new(string name = "ahb_xtn");
    extern function void do_print(uvm_printer printer);
endclass


function ahb_xtn::new(string name = "ahb_xtn");
	super.new(name);
endfunction



function void  ahb_xtn::do_print (uvm_printer printer);
    super.do_print(printer);

printer.print_field("Haddr",    this.Haddr,      32, UVM_HEX);
  printer.print_field("Hwdata",   this.Hwdata,     32, UVM_HEX);
  printer.print_field("Hrdata",   this.Hrdata,     32, UVM_HEX);
  printer.print_field("Hwrite",   this.Hwrite,      1, UVM_DEC);
  printer.print_field("Htrans",   this.Htrans,      2, UVM_DEC);
  printer.print_field("Hsize",    this.Hsize,       3, UVM_DEC);
  printer.print_field("Hburst",   this.Hburst,      3, UVM_DEC);
  printer.print_field("length",   this.length,     32, UVM_DEC);

endfunction
	  

