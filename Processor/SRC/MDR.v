module MDR(input [7:0] DRAM_to_MDR,
		   input [7:0] bus_to_MDR,
		   input clock,
	       input [1:0] MDR_control,
		   output [7:0] MDR_to_bus,
		   output [7:0] MDR_to_DRAM);

reg [7:0] MDR;
assign MDR_to_bus = MDR;
assign MDR_to_DRAM = MDR;
			  
always@(posedge clock)
begin
	case(MDR_control)
	2'b00:
		begin
		MDR <= MDR;
		end
	2'b01:
		begin
		MDR <= DRAM_to_MDR;
		end
	2'b10:
		begin
		MDR <= bus_to_MDR;
		end
	default:
		begin
		MDR <= MDR;
		end
	endcase
end

endmodule