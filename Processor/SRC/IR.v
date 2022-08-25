module IR(  input clock,
			input wire [15:0] IRAM_data, // data bus from IRAM
			input wire load_instruction, //control signal
			output reg [15:0] instruction); // output bus


initial
begin
instruction=16'b0; // Setting to zero at very begining
end	
						
always @(posedge load_instruction)
begin
instruction=IRAM_data; //at every pos edge IRAM data is written
end

endmodule