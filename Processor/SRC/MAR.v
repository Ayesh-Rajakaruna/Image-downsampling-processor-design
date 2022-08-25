module MAR(input [15:0] AC_to_MAR,
		   input [7:0] RRR_in,
		   input [7:0] CRR_in,
		   input [7:0] RWR_in,
		   input [7:0] CWR_in,
		   input clock,
		   input [1:0] MAR_control,
		   output wire [15:0] MAR_to_DRAM);
			  
reg [15:0] MAR;
assign MAR_to_DRAM = MAR;
			  
always@(posedge clock)
begin
	case(MAR_control)
	2'b00:
		begin
			MAR <= MAR;
		end
	2'b01:
		begin
			MAR <= AC_to_MAR;
		end
	2'b10:
		begin
			MAR <= {RRR_in,CRR_in[6:0]};
		end
	2'b11:
		begin
			MAR <= {RWR_in,CWR_in[6:0]};
		end
	default:
		begin
			MAR <= MAR;
		end
	endcase
end
			  			  
endmodule

