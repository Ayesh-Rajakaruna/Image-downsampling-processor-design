module Read_registers(input [7:0] IDC_control_RRR,
					  input [7:0] IDC_control_CRR,
					  output [7:0] RRR_out,
				  	  output [7:0] CRR_out);
							 
reg [7:0] RRR;
reg [7:0] CRR;
assign RRR_out = RRR;
assign CRR_out = CRR;

always@(IDC_control_RRR)
begin
	RRR <= IDC_control_RRR;
end
	
always@(IDC_control_CRR)
begin
	CRR <= IDC_control_CRR;
end
							 
endmodule