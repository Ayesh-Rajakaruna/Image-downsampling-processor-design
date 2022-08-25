module Top_Level_Module(input clk, output Tx_ready);
								
wire [7:0] IRAM_address;
wire [15:0] IRAM_to_processor;
wire [15:0] DRAM_address;
wire [7:0] DRAM_write_data;
wire write_DRAM;
wire [15:0] DRAM_address_processor;
wire [7:0] DRAM_to_processor;
wire start_Tx;
								
IRAM IRAM(.address(IRAM_address),
		.clock(clk),
		.q(IRAM_to_processor));
		
DRAM DRAM(.address(DRAM_address),
		.clock(clk),
		.data(DRAM_write_data),
		.wren(write_DRAM),
		.q(DRAM_to_processor));
		
Processor Processor(.IRAM_address(IRAM_address),
						  .IRAM_data(IRAM_to_processor),
						  .clock(clk),
						  .DRAM_address_processor(DRAM_address),
						  .DRAM_output_data(DRAM_write_data),
						  .DRAM_input_data(DRAM_to_processor),
						  .write_DRAM(write_DRAM),
						  .start_Tx(Tx_ready)
						  );			 
Writedata Writedata(.wren(write_DRAM),
                    .clock(clk),
                    .data(DRAM_write_data),
                    .IRAM_address(IRAM_address)
                    );
				  
endmodule