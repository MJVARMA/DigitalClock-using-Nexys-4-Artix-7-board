module tb_clock;
reg clk;
reg rst;
wire [5:0]S;
wire [5:0]M;
wire [4:0]H;
Clock X1(clk,rst,H,M,S);
initial clk= 0;
always #1 clk = ~clk;
initial begin
rst = 1;
#5;
rst = 0; 
#5000 $stop;
end
endmodule
