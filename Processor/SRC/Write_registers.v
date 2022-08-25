module Write_registers(input [7:0] IDC_control_RWR,
					   input [7:0] IDC_control_CWR,
				       output [7:0] RWR_out,
					   output [7:0] CWR_out);
							 
reg [7:0] RWR;
reg [7:0] CWR;
assign RWR_out = RWR;
assign CWR_out = CWR;

always@(IDC_control_RWR)
begin
	RWR <= IDC_control_RWR;
end
	
always@(IDC_control_CWR)
begin
	CWR <= IDC_control_CWR;
end
							 
endmodule