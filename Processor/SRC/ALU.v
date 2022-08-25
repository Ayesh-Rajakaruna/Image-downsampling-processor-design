module ALU(   input wire [15:0] B, // Bus 16bit
			  input wire [3:0] ALU_control, //Control signal 4bit
			  input wire [15:0] instruction, 
			  output wire [15:0] AC_out, //Acculumator 16bit
			  //output wire [7:0] AC_LED,
			  output wire Z_out, //for flag
			  input wire clock);

reg [15:0] AC;
reg [11:0] load_constant;
reg Z;
assign AC_out = AC;
//assign AC_LED = AC[7:0];
assign Z_out = Z;

initial
begin
AC = 16'b0;
end

always@(instruction)
begin
	load_constant = instruction[11:0];
end

always @(AC) //Flag
	begin
		if(AC==16'b0) //checking if AC==0
			Z <= 1; 
		else 
			Z <= 0;
	end
			
always @(posedge clock)
begin
	case(ALU_control)
	4'b0000: //Pass the value
	begin
		AC <= AC;
	end
	
	4'b0001: //Add AC to bus
	begin
		AC <= AC+B;
	end
	
	4'b0010: //Subtract bus from AC
	begin
		AC <= AC-B;
	end
	
	4'b0011:  //Multiply bus by AC
	begin 
		AC <= AC*B;
	end
	
	4'b0100: //Divide AC by bus
	begin
		AC <= AC/B;
	end
	
	4'b0101: //Set bus value to AC
	begin
		AC <= B;
	end
	
	4'b0110: //Load constant
	begin
		AC <= {4'b0,load_constant}; // "0000"+"12 bit value from instruction"
	end
	
	4'b0111: //Increment AC by 1
	begin
		AC <= AC + 16'd1;
	end
	
	4'b1000: //Decrement AC by 1
	begin
		AC <= AC - 16'd1;
	end
	
	4'b1001: //Set AC=0
	begin
		AC <= 16'b0;
	end
	endcase
end

endmodule