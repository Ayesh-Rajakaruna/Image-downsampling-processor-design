module Bus(input wire [15:0] AC_in,
		   input wire [7:0] SR1_in,
		   input wire [7:0] SR2_in,
		   input wire [7:0] SR3_in,
		   input wire [15:0] R1_in,
		   input wire [15:0] R2_in,
		   input wire [7:0] RRR_in,
		   input wire [7:0] CRR_in,
		   input wire [7:0] MDR_in,
		   input wire [3:0] select_source,
		   input wire [2:0] select_destination,
		   input wire [15:0] instruction,
		   input clock,
		   output reg [7:0] SR1_out,
		   output reg [15:0] R1_out,
		   output reg [15:0] R2_out,
		   output wire [7:0] MDR_out,
		   output wire [15:0] B_out,
		   output wire SR_en);

reg [15:0] value;
reg [3:0] multiply_divide_constant;
reg  SR_EN;
assign B_out = value;
assign MDR_out = value[7:0];
assign SR_en = SR_EN;

initial
begin
value = 16'b0000000000000111; //inital value of the Bus (B_out)
end

always@(instruction)
begin
	multiply_divide_constant <= instruction[11:8];
end

always@(posedge clock)
	begin
		case(select_source) //selecting a source for the Bus
		4'b0000:
			begin
				value <= value;
			end
		
		4'b0001:
			begin
				value <= AC_in;
			end
		
		4'b0101:
			begin
				value <= {8'b0,MDR_in};
			end
			
		4'b0110:
			begin
				value <= {8'b0,SR1_in};
			end
			
		4'b0111:
			begin
				value <= {8'b0,SR2_in};
			end
			
		4'b1000:
			begin
				value <= {8'b0,SR3_in};
			end
			
		4'b0010:
			begin
				value <= R1_in;
			end
			
		4'b0011:
			begin
				value <= R2_in;
			end
			
		4'b1001:
			begin
				value <= {8'b0,RRR_in};
			end
			
		4'b1010:
			begin
				value <= {8'b0,CRR_in};
			end
			
		4'b1011:
			begin
				value <= {12'b0,multiply_divide_constant};
			end
		
		endcase
	end
	
	
always@(negedge clock)
	begin
		case(select_destination) //selecting a destination for the Bus
		3'b000:
			begin
				value <= value;
				SR_EN <= 0;
			end
		
		3'b010:
			begin
				R1_out <= value;
				SR_EN <= 0;
			end
			
		3'b011:
			begin
				R2_out <= value;
				SR_EN <= 0;
			end
			
		3'b110:
			begin
				SR1_out <= value[7:0];
				SR_EN <= 1;
			end
					
		endcase
	end
	
endmodule		  
			  