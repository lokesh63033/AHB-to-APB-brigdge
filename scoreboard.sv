class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard);
env_config m_cfg;
ahb_xtn ahb;
apb_xtn apb;

uvm_tlm_analysis_fifo #(ahb_xtn) ahb_fifo;
uvm_tlm_analysis_fifo #(apb_xtn) apb_fifo;

///////////////////////////ahb////////////////////////////

covergroup ahb_cg;
option.per_instance=1;

HADDR:coverpoint ahb.Haddr{bins addr0={[32'h8000_0000 : 32'h8000_03ff]};
			   bins addr1={[32'h8400_0000 : 32'h8400_03ff]};
			   bins addr2={[32'h8800_0000 : 32'h8800_03ff]};
			   bins addr3={[32'h8c00_0000 : 32'h8c00_03ff]};}

HWRITE:coverpoint ahb.Hwrite{bins wrt0={0,1};}
 
HTRANS:coverpoint ahb.Htrans{bins trans0={2,3};}

HSIZE:coverpoint ahb.Hsize{bins size0={0,1,2};}

AHB_C:cross HADDR,HWRITE,HTRANS,HSIZE;

endgroup

///////////////////////////////apb/////////////////////////////

covergroup apb_cg;
option.per_instance=1;
PADDR:coverpoint apb.Paddr{bins addr0={[32'h8000_0000 : 32'h8000_03ff]};
			   bins addr1={[32'h8400_0000 : 32'h8400_03ff]};
			   bins addr2={[32'h8800_0000 : 32'h8800_03ff]};
			   bins addr3={[32'h8c00_0000 : 32'h8c00_03ff]};}

PWRITE:coverpoint apb.Pwrite{bins pwrt0={0,1};}

PSELX:coverpoint apb.Pselx{bins sel0={1,2,4,8};}

APB_C:cross PADDR,PWRITE,PSELX;
endgroup



/////////////////////////////////constructor////////////////////

function new(string name, uvm_component parent);
super.new(name,parent);
apb_cg=new;
ahb_cg=new;
endfunction
///////////////////////////////build phase ///////////////////////

function void build_phase(uvm_phase phase);
	if(!uvm_config_db#(env_config)::get(null,get_full_name(),"env_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg")
apb_fifo=new("apb_fifo",this);
ahb_fifo=new("ahb_fifo",this);

endfunction

////////////////////////////run phase////////////////
task run_phase(uvm_phase phase);
	forever
		begin
			fork
				begin
					ahb_fifo.get(ahb);
					ahb.print();
					ahb_cg.sample();
				end
				
				begin
					apb_fifo.get(apb);
					apb.print();
					apb_cg.sample();
				end
			join
				check_data(ahb,apb);
		end
endtask

////////////////////////compare///////////////////////
task compare(int Haddr,Paddr,Hdata,Pdata);
	if(Haddr==Paddr)
		$display("success");
	else
		$display("fail");

	if(Hdata==Pdata)
		$display("success");
	else
		$display("fail");
endtask

/////////////////////////check////////////////////////////

task check_data(ahb_xtn ahb,apb_xtn apb);
	if(ahb.Hwrite==1)
		begin
			if(ahb.Hsize==0)
				begin
					if(ahb.Haddr[1:0]==2'b00)
						compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[7:0],apb.Pwdata[7:0]);
  					if(ahb.Haddr[1:0]==2'b01)
						compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:8],apb.Pwdata[7:0]);
					if(ahb.Haddr[1:0]==2'b10)
						compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[23:16],apb.Pwdata[7:0]);
					if(ahb.Haddr[1:0]==2'b11)
						compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:24],apb.Pwdata[7:0]);
				end

			if(ahb.Hsize==1)
				begin
					if(ahb.Haddr[1:0]==2'b00)
						compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:0],apb.Pwdata[15:0]);
					if(ahb.Haddr[1:0]==2'b10)
						compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:16],apb.Pwdata[15:0]);
				end

			if(ahb.Hsize==2)
				begin
					//	if(ahb.Haddr[1:0]==2'b00)
					compare(ahb.Haddr,apb.Paddr,ahb.Hwdata,apb.Pwdata);
				end
		end

	if(apb.Pwrite==1)
			
		begin
			if(ahb.Hsize==0)
				begin
					if(ahb.Haddr[1:0]==2'b00)
						compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[7:0],apb.Pwdata[7:0]);
					if(ahb.Haddr[1:0]==2'b01)
						compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:8],apb.Pwdata[7:0]);
					if(ahb.Haddr[1:0]==2'b10)
						compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[23:16],apb.Pwdata[7:0]);
					if(ahb.Haddr[1:0]==2'b11)
						compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:24],apb.Pwdata[7:0]);
				end

			if(ahb.Hsize==1)
				begin
					if(ahb.Haddr[1:0]==2'b00)
						compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:0],apb.Pwdata[15:0]);	
					if(ahb.Haddr[1:0]==2'b10)
						compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:16],apb.Pwdata[15:0]);
				end

			if(ahb.Hsize==2)
				begin
				//	if(ahb.Haddr[1:0]==2'b00)
					compare(ahb.Haddr,apb.Paddr,ahb.Hwdata,apb.Pwdata);
				end
			end
endtask

endclass

