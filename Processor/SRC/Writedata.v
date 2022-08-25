module Writedata(input wren,
                 input wire [7:0] data,
                 input clock,             
                 input wire [7:0] IRAM_address
                 );

//reg [7:0] Inputdata;
integer file;
reg [15:0] Check; 



initial begin 
Check=0;
file = $fopen("C:\\Users\\Ayesh\\Desktop\\Project\\Processor\\SRC\\output.txt","w");
end

always@(negedge clock)
begin  
    case (wren)
        1:
        begin
         if (IRAM_address == 80)
          begin
		   $fdisplay(file,"%d",data);
		   Check=Check+1;
		  end 
		   //$fdisplay(file,"%d",data);
		   
		// else
		  // $display("test");
		end
	 endcase
end



//initial
//$fclose(file);

endmodule