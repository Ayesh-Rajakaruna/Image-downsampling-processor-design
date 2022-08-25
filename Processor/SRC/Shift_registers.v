module shift_registers(input wire [7:0] bus_to_SR1,
                       input clock,
                       input SR_en,
					   output wire [7:0] SR1_to_bus,
					   output wire [7:0] SR2_to_bus,
					   output wire [7:0] SR3_to_bus);

reg [7:0] SR1;
reg [7:0] SR2;
reg [7:0] SR3;
	
assign SR1_to_bus = SR1;
assign SR2_to_bus = SR2;
assign SR3_to_bus = SR3;
						  
always@(posedge clock)
begin  
    case (SR_en)
        1:
        begin
		  SR3 <= SR2;
		  SR2 <= SR1;
		  SR1 <= bus_to_SR1;
		end
	endcase
end
endmodule