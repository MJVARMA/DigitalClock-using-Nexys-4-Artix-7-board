`timescale 1ns / 1ps

// Engineer: Jagannadha Varma Mandhapati
// Project Name: Digital clock using Nexys 4 Artix-7 board


module Clock(clk,rst,H,M,S);
input clk,rst;
output [5:0]M;
output [5:0]S;
output [4:0]H;
reg [4:0]H;
reg [5:0]M;
reg [5:0]S;
wire clkout;
clockdivider C1234(clk,clkout);
always@(posedge clkout or posedge rst)
begin
if(rst==1'b1)
begin
S=6'b000000;
M=6'b000000;
H=5'b00000;
end
else if(clkout==1'b1)begin
S=S+1'b1;
if(S==6'b111100)begin
M=M+1'b1;
S=6'b000000;
if(M==6'b111100)begin
H=H+1'b1;
M=6'b000000;
if(H==5'b11000)begin
H=5'b00000;
end
end
end
end
end
endmodule


module SevenSeg(clk,data,an,seg);
input clk;
input [63:0]data;
output reg[7:0]an,seg;
reg[19:0]counter=0;

always@(posedge clk)
counter=counter+1;

always@(counter)
begin
case(counter[19:17])
3'b000:begin
seg=data[7:0];
an=8'b11111110;
end
3'b001:begin
seg=data[15:8];
an=8'b11111101;
end
3'b010:begin
seg=data[23:16];
an=8'b11111011;
end
3'b011:begin
seg=data[31:24];
an=8'b11110111;
end
3'b100:begin
seg=data[39:32];
an=8'b11101111;
end
3'b101:begin
seg=data[47:40];
an=8'b11011111;
end
3'b110:begin
seg=data[55:48];
an=8'b10111111;
end
3'b111:begin
seg=data[63:56];
an=8'b01111111;
end
endcase
end
endmodule

module sevenseginterface(clk,rst,H,M,S);
input clk,rst;
output [4:0]H;
output [5:0]M,S;
reg [63:0]data;
wire [7:0]A[9:0];
reg [7:0]P,Q,R;
assign A[0]=8'hC0;
assign A[1]=8'hF9;
assign A[2]=8'hA4;
assign A[3]=8'hB0;
assign A[4]=8'h99;
assign A[5]=8'h92;
assign A[6]=8'h82;
assign A[7]=8'hF8;
assign A[8]=8'h80;
assign A[9]=8'h90;
Clock clo(clk,rst,H,M,S);
always@(*)
begin
P={3'b000,H};
Q={2'b00,M};
R={2'b00,S};
data={A[P/10],A[P%10],8'h7F,A[Q/10],A[Q%10],8'h7F,A[R/10],A[R%10]};
end
SevenSeg s123(clk,data,an,seg);
endmodule

module clockdivider(clk,clkout);
input clk;
output reg clkout;
integer counter;
initial
begin
clkout=0;
counter=0;
end
always@(posedge clk)
begin
if(counter>=50000000-1)
begin
clkout=~clkout;
counter=0;
end
else
counter=counter+1;
end
endmodule

module topmod(seg,an,clk,sw);
input sw;
input clk;
output [7:0]seg,an;
sevenseginterface i1234(clk,sw,seg,an);
endmodule


