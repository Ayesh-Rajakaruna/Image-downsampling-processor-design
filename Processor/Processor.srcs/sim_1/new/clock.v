module clock();
    `timescale 1ns/1ps 
    reg clk;
    Top_Level_Module clock(.clk(clk));
    

    initial 
        begin
        clk = 0;
        end
    always 
    begin
    #40 clk = ~clk;    
    end
endmodule