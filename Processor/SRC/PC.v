module PC(input wire Z_out,
		  input [1:0] PC_control,
		  input clock,
		  input wire [15:0] instruction, // instrution contains both jump address & jump condition
		  output wire [7:0] IRAM_address);		  
		  
reg [7:0] PC;
reg [7:0] jump_address;
reg [3:0] jump_condition;
assign IRAM_address = PC;

initial
begin
PC <= 8'b0;
end

always@(instruction)
begin
	jump_address <= instruction[7:0];
	jump_condition <= instruction[11:8];
end
							  
always@(posedge clock)
begin
	if (PC_control==2'b10)
	begin
		case(jump_condition)
		4'b0000:
			begin
			PC <= jump_address;
			end
		4'b0001:
			if (Z_out==0)
			begin
				PC <= jump_address;
			end
			else
				PC <= PC;
		4'b0010:
			if (Z_out==1)
			begin
				PC <= jump_address;
			end
			else
				PC <= PC;
	
		default: PC <= PC;
		endcase
	end
	else if (PC_control==2'b01)
		PC <= PC + 8'd1; //increment the PC by 1
	else
		PC <= PC;
end
							  
endmodule