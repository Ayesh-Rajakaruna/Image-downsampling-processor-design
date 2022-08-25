module R(input [15:0] bus_to_R,
		 output [15:0] R_to_bus);

reg [15:0] value;
assign R_to_bus = value;
			
always@(bus_to_R)
begin
value = bus_to_R;
end

endmodule



