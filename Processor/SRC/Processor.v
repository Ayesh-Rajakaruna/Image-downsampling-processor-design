module Processor(input wire clock,
                 input wire [15:0] IRAM_data,
		         input wire [7:0] DRAM_input_data,
			     //input wire enable_processor,
			     output wire [7:0] IRAM_address,
			     output wire [15:0] DRAM_address_processor,
			     output wire [7:0] DRAM_output_data,					  
			     output wire write_DRAM,				  
			     output wire start_Tx
			     //output wire [5:0] LED,
			     //output wire [7:0] AC_LED
			     );
					  
wire SR_enable;
wire load_instruction;
wire [15:0] instruction;
wire [3:0] ALU_control;
wire [3:0] select_source;
wire [2:0] select_destination;
wire [15:0] AC_to_Bus;
wire [15:0] Bus_to_B;
wire [3:0] multiply_divide_constant;
wire [15:0] bus_to_R1;
wire [15:0] R1_to_bus;
wire [15:0] bus_to_R2;
wire [15:0] R2_to_bus;
wire [11:0] load_constant;
wire [7:0] bus_to_SR1;
wire [7:0] SR1_to_bus;
wire [7:0] SR2_to_bus;
wire [7:0] SR3_to_bus;
wire [1:0] IDC_control;
wire [1:0] PC_control;
wire [7:0] IDC_control_RRR;
wire [7:0] IDC_control_RWR;
wire [7:0] IDC_control_CRR;
wire [7:0] IDC_control_CWR;
wire [7:0] RRR_out;
wire [7:0] CRR_out;
wire [7:0] RWR_out;
wire [7:0] CWR_out;
wire [1:0] MDR_control;
wire [7:0] bus_to_MDR;
wire [7:0] MDR_to_bus;
wire [1:0] MAR_control;
wire Z_out;
					  
statemachine statemachine(.instruction(instruction),
						  .clock(clock),
						  //.enable_processor(enable_processor),
						  .load_instruction(load_instruction),
						  .ALU_control(ALU_control),
						  .select_source(select_source),
						  .select_destination(select_destination),
						  .PC_control(PC_control),
						  .IDC_control(IDC_control),
						  .MDR_control(MDR_control),
						  .MAR_control(MAR_control),
						  .write_DRAM(write_DRAM),
						  .start_Tx(start_Tx)
						  //.LED(LED)
						  );	
			 
IR IR(.clock(clock),
	  .IRAM_data(IRAM_data),
	  .instruction(instruction),
	  .load_instruction(load_instruction));
		
ALU ALU(.B(Bus_to_B),
		.ALU_control(ALU_control),
    .AC_out(AC_to_Bus),
	    .Z_out(Z_out),
	    .instruction(instruction),
	    //.AC_LED(AC_LED),
	    .clock(clock));
		
Bus Bus(.AC_in(AC_to_Bus),
		.SR1_in(SR1_to_bus),
	    .SR2_in(SR2_to_bus),
	    .SR3_in(SR3_to_bus),
	    .R1_in(R1_to_bus),
	    .R2_in(R2_to_bus),
	    .RRR_in(RRR_out),
        .CRR_in(CRR_out),
	    .MDR_in(MDR_to_bus),
	    .SR1_out(bus_to_SR1),
	    .R1_out(bus_to_R1),
	    .R2_out(bus_to_R2),
	    .MDR_out(bus_to_MDR),
	    .B_out(Bus_to_B),
	    .select_source(select_source),
	    .select_destination(select_destination),
	    .instruction(instruction),
	    .clock(clock),
	    .SR_en(SR_enable));
	  
PC PC(.Z_out(Z_out),
	  .PC_control(PC_control),
	  .IRAM_address(IRAM_address),
	  .clock(clock),
	  .instruction(instruction));
							  
IDC_controller IDC_controller(.IDC_control(IDC_control),
							  .instruction(instruction),
						      .IDC_control_RRR(IDC_control_RRR),
						      .IDC_control_RWR(IDC_control_RWR),
						      .IDC_control_CRR(IDC_control_CRR),
						      .IDC_control_CWR(IDC_control_CWR),
						      .clock(clock));
							  
			  
R R1(.R_to_bus(R1_to_bus),
	 .bus_to_R(bus_to_R1));
	  
R R2(.R_to_bus(R2_to_bus),
	 .bus_to_R(bus_to_R2));
	  
shift_registers shift_registers(.bus_to_SR1(bus_to_SR1),
								.SR1_to_bus(SR1_to_bus),
					            .SR2_to_bus(SR2_to_bus),
							    .SR3_to_bus(SR3_to_bus),
							    .SR_en(SR_enable),
							    .clock(clock));
										  
Read_registers Read_registers(.IDC_control_RRR(IDC_control_RRR),
							  .IDC_control_CRR(IDC_control_CRR),
							  .RRR_out(RRR_out),
							  .CRR_out(CRR_out));
							 
Write_registers Write_registers(.IDC_control_RWR(IDC_control_RWR),
							    .IDC_control_CWR(IDC_control_CWR),
							    .RWR_out(RWR_out),
							    .CWR_out(CWR_out));
										  
MDR MDR(.DRAM_to_MDR(DRAM_input_data),
		.bus_to_MDR(bus_to_MDR),
		.clock(clock),
		.MDR_to_bus(MDR_to_bus),
		.MDR_to_DRAM(DRAM_output_data),
		.MDR_control(MDR_control));
		 
MAR MAR(.AC_to_MAR(AC_to_Bus),
		.RRR_in(RRR_out),
		.CRR_in(CRR_out),
		.RWR_in(RWR_out),
		.CWR_in(CWR_out),
		.MAR_to_DRAM(DRAM_address_processor),
		.clock(clock),
		.MAR_control(MAR_control));
											
endmodule
					  
