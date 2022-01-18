module divider1 (
	input clk,
	output reg clk_1
);
parameter NUM_DIV =100000000 ;
reg [31:0]cnt;
always @(posedge clk) begin
	if(cnt<NUM_DIV/2-1)begin
		cnt<=cnt+1'b1;
		clk_1<=clk_1;
	end	
	else begin
		cnt<=32'b0;
		clk_1<=~clk_1;
	end
end
endmodule


module TimeDeal  (
	input clk,//1s
	input rst_n,
	output [3:0]min_l,
	output [3:0]min_h,
	output [3:0]sec_l,
	output [3:0]sec_h
);

reg[3:0]dout1;
reg[3:0]dout2;
reg[3:0]dout3;
reg[3:0]dout4;
//秒的高、低位，分钟的高、低位
reg carry1,carry2,carry3;
//进位

//先处理秒的低位
always @(posedge clk or negedge rst_n)  begin
	if(!rst_n)
		dout1<=0;
	else begin
		if(dout1<9)begin
			dout1<=dout1+1'b1;
			carry1<=0;
		end
		else begin
			dout1<=0;
			carry1<=1'b1;
		end
		
	end
end

//再处理秒的高位
always @(posedge carry1 or negedge rst_n) begin
	if(!rst_n)
		dout2<=0;
	else begin
		if(dout2<5)begin
			dout2<=dout2+1'b1;
			carry2<=0;
		end
		else begin
			dout2<=0;
			carry2<=1'b1;
		end
	end
end

//再处理分钟的低位
always @(posedge carry2 or negedge rst_n) begin
	if(!rst_n)
		dout3<=0;
	else begin
		if(dout3<9)begin
			dout3<=dout3+1'b1;
			carry3<=0;
		end
		else begin
			dout3<=0;
			carry3<=1'b1;
		end
	end
end

//再处理分钟的低位
always @(posedge carry3 or negedge rst_n) begin
	if(!rst_n)
		dout4<=0;
	else begin
		if(dout4<6)begin
			dout4<=dout4+1'b1;
		end
		else begin
			dout4<=0;
		end
	end
end

assign sec_l=dout1;
assign sec_h=dout2;
assign min_l=dout3;
assign min_h=dout4;

endmodule
