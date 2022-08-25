module statemachine(input [15:0] instruction,
					input clock,
					output reg load_instruction,
					output reg [3:0] ALU_control,
					output reg [3:0] select_source,
					output reg [2:0] select_destination,
					output reg [1:0] IDC_control,
					output reg [1:0] MDR_control,
					output reg [1:0] MAR_control,
					output reg [1:0] PC_control,
					output reg write_DRAM,
					output reg start_Tx
					);
		
							
reg [4:0] state;
reg [3:0] source_register;
reg [2:0] destination_register;
reg [3:0] opcode;

initial
begin
	state = 5'b10000; //start
end

always@(instruction)
begin
	opcode = instruction[15:12];
	source_register = instruction[11:8];
	destination_register = instruction[2:0];
end

always@(negedge clock)
begin
	case(state)
		5'b10000: //start (16)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10001; //fetch1							
			end
			
		5'b10001: //fetch1 (17)
			begin
				load_instruction <= 1; //read IRAM
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10010; //fetch2
			end
			
		5'b10010: //fetch2 (18)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b01; //increment PC
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= {1'b0, opcode}; //loaded instruction
			end
			
		5'b00101: //add1 (5)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= source_register; //copy register to the Bus
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10011; //add2
			end
		
		5'b10011: //add2 (19)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0001; // AC + Bus
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10001; //fetch1
			end
			
		5'b00110: //sub1 (6)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= source_register; //copy register to the Bus
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10100; //add2
			end
		
		5'b10100: //sub2 (20)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0010; // AC - Bus
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10001; //fetch1
			end
			
		5'b00111: //mul1 (7)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b1011;  //copy constant(from instruction) to the Bus
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10101; //mul2
			end
			
		5'b10101: //mul2 (13)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0011; // AC * Bus
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10001; //fetch1
			end
			
		5'b01000: //div1 (8)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b1011; //copy constant(from instruction) to the Bus
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10110; //div2
			end
			
		5'b10110: //div2 (22)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0100; // AC / Bus
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10001; //fetch1
			end
			
		5'b00011: //copy (3)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= source_register; //copy register to the Bus
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10111; //copy2
			end
			
		5'b10111: //copy2 (23)
			begin
				load_instruction <= 0;
				if (destination_register == 3'b001) //If the destination is AC
					ALU_control <= 4'b0101;         //Set Bus value to AC
				else
					ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				if (destination_register == 3'b001) //If the destination is AC
					select_destination <= 3'b000;
				else
					select_destination <= destination_register; //Assignthe destination to Bus
				if (destination_register == 3'b101) //If the destination is MDR
					MDR_control <= 2'b10;           //Set Bus value to MDR
				else
					MDR_control <= 2'b00;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10001; //fetch1
			end
			
		5'b01100: //loadk (12)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0110; //copy constant(from instruction) to the AC
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10001; //fetch1
			end
			
		5'b00100: //jump (4)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b10; //copy Address(from instruction) to the PC
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10001; //fetch1
			end
			
		5'b01010: //inc (10)
			begin
				load_instruction <= 0;
				if (source_register == 4'b0001) //If the source register is AC
					ALU_control <= 4'b0111;     //increment AC by 1
				else
					ALU_control <= 4'b0000;
				if (source_register == 4'b0001) //If the source register is AC
					IDC_control <= 2'b00;
				else	
					IDC_control <= 2'b01;       //increment done via IDC controller
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10001; //fetch1
			end
			
		5'b01011: //dec (11)
			begin
				load_instruction <= 0;
				if (source_register == 4'b0001) //If the source register is AC
					ALU_control <= 4'b1000;     //decrement AC by 1
				else
					ALU_control <= 4'b0000;     
				if (source_register == 4'b0001) //If the source register is AC
					IDC_control <= 2'b00;
				else	
					IDC_control <= 2'b10;       //deccrement done via IDC controller
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10001; //fetch1
			end
			
		5'b01001: //clr (9)
			begin
				load_instruction <= 0;
				if (source_register == 4'b0001) //If the source register is AC
					ALU_control <= 4'b1001;     // AC = 0
				else
					ALU_control <= 4'b0000;
				if (source_register == 4'b0001) //If the source register is AC
					IDC_control <= 2'b00;
				else	
					IDC_control <= 2'b11;       //clear done via IDC controller
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10001; //fetch1
			end
			
		5'b00001: //load1 (1)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				if (source_register == 4'b0001)      //If the source register is AC 
					MAR_control <= 2'b01;            // MAR <= AC
				else if (source_register == 4'b0010) //If the source register is RR
					MAR_control <= 2'b10;            // MAR <= {RRR,CRR}
				else
					MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b11000; //load2
			end
			
		5'b11000: //load2 (24)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b01; // MDR <= DRAM
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b10001; //fetch1
			end
			
		5'b00010: //store1 (2)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				if (source_register == 4'b0001)      //If the source register is AC 
					MAR_control <= 2'b01;            // MAR <= AC
				else if (source_register == 4'b0010) //If the source register is WR 	
					MAR_control <= 2'b11;            // MAR <= {RWR,CWR}
				else
					MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 5'b11001; //store2
			end
			
		5'b11001: //store2 (25)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 1; // DRAM <= MDR
				start_Tx <= 0;
				state <= 5'b10001; //fetch1
			end
		
		5'b00000: //nop (0)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;       
				state <= 5'b10001; //fetch1
			end
			
		5'b01111: //end (15)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 1;        //indicate that the processing is done
				state <= 5'b01111; //end
			end
			
		default: state <= 5'b10000; // start 
      endcase
	end
endmodule