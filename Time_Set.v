module Time_Set(
	 input[3:0]num,
	 input rst_n,
	 output reg[7:0]row0,
	 output reg[7:0]row1,
	 output reg[7:0]row2,
	 output reg[7:0]row3,
	 output reg[7:0]row4,
	 output reg[7:0]row5,
	 output reg[7:0]row6,
	 output reg[7:0]row7,
	 output reg[7:0]row8,
	 output reg[7:0]row9,
	 output reg[7:0]row10,
	 output reg[7:0]row11,
	 output reg[7:0]row12,
	 output reg[7:0]row13,
	 output reg[7:0]row14,
	 output reg[7:0]row15
);
always@(*) begin
	if(!rst_n)begin
	row0<=0;	row1<=0;	row2<=0;	row3<=0;
	row4<=0;	row5<=0;	row6<=0;	row7<=0;
	row8<=0;	row9<=0;	row10<=0;	row11<=0;
	row12<=0;	row13<=0;	row14<=0;	row15<=0;
	end
	else begin
		case(num)
		4'b0000:begin
		row0<=8'h00;		row1<=8'h00;		row2<=8'h00;		row3<=8'h18;
		row4<=8'h24;		row5<=8'h42;		row6<=8'h42;		row7<=8'h42;
		row8<=8'h42;		row9<=8'h42;		row10<=8'h42;		row11<=8'h42;
		row12<=8'h24;		row13<=8'h18;		row14<=8'h00;		row15<=8'h00;
		end
		4'b0001:begin
		row0<=8'h00;		row1<=8'h00;		row2<=8'h00;		row3<=8'h08;
		row4<=8'h38;		row5<=8'h08;		row6<=8'h08;		row7<=8'h08;
		row8<=8'h08;		row9<=8'h08;		row10<=8'h08;		row11<=8'h08;
		row12<=8'h08;		row13<=8'h3E;		row14<=8'h00;		row15<=8'h00;
		end
		4'b0010:begin
		row0<=8'h00;		row1<=8'h00;		row2<=8'h00;		row3<=8'h3C;
		row4<=8'h42;		row5<=8'h42;		row6<=8'h42;		row7<=8'h02;
		row8<=8'h04;		row9<=8'h08;		row10<=8'h10;		row11<=8'h20;
		row12<=8'h42;		row13<=8'h7E;		row14<=8'h00;		row15<=8'h00;
		end
		4'b0011:begin
		row0<=8'h00;		row1<=8'h00;		row2<=8'h00;		row3<=8'h3C;
		row4<=8'h42;		row5<=8'h42;		row6<=8'h02;		row7<=8'h04;
		row8<=8'h18;		row9<=8'h04;		row10<=8'h02;		row11<=8'h42;
		row12<=8'h42;		row13<=8'h3C;		row14<=8'h00;		row15<=8'h00;
		end
		4'b0100:begin
		row0<=8'h00;		row1<=8'h00;		row2<=8'h00;		row3<=8'h04;
		row4<=8'h0C;		row5<=8'h0C;		row6<=8'h14;		row7<=8'h24;
		row8<=8'h24;		row9<=8'h44;		row10<=8'h7F;		row11<=8'h04;
		row12<=8'h04;		row13<=8'h1F;		row14<=8'h00;		row15<=8'h00;
		end
		4'b0101:begin
		row0<=8'h00;		row1<=8'h00;		row2<=8'h00;		row3<=8'h7E;
		row4<=8'h40;		row5<=8'h40;		row6<=8'h40;		row7<=8'h78;
		row8<=8'h44;		row9<=8'h02;		row10<=8'h02;		row11<=8'h42;
		row12<=8'h44;		row13<=8'h38;		row14<=8'h00;		row15<=8'h00;
		end
		4'b0110:begin
		row0<=8'h00;		row1<=8'h00;		row2<=8'h00;		row3<=8'h18;
		row4<=8'h24;		row5<=8'h40;		row6<=8'h40;		row7<=8'h5C;
		row8<=8'h62;		row9<=8'h42;		row10<=8'h42;		row11<=8'h42;
		row12<=8'h22;		row13<=8'h1C;		row14<=8'h00;		row15<=8'h00;
		end
		4'b0111:begin
		row0<=8'h00;		row1<=8'h00;		row2<=8'h00;		row3<=8'h7E;
		row4<=8'h42;		row5<=8'h04;		row6<=8'h04;		row7<=8'h08;
		row8<=8'h08;		row9<=8'h10;		row10<=8'h10;		row11<=8'h10;
		row12<=8'h10;		row13<=8'h10;		row14<=8'h00;		row15<=8'h00;
		end
		4'b1000:begin
		row0<=8'h00;		row1<=8'h00;		row2<=8'h00;		row3<=8'h3C;
		row4<=8'h42;		row5<=8'h42;		row6<=8'h42;		row7<=8'h24;
		row8<=8'h18;		row9<=8'h24;		row10<=8'h42;		row11<=8'h42;
		row12<=8'h42;		row13<=8'h3C;		row14<=8'h00;		row15<=8'h00;
		end
		4'b1001:begin
		row0<=8'h00;		row1<=8'h00;		row2<=8'h00;		row3<=8'h38;
		row4<=8'h44;		row5<=8'h42;		row6<=8'h42;		row7<=8'h42;
		row8<=8'h46;		row9<=8'h3A;		row10<=8'h02;		row11<=8'h02;
		row12<=8'h24;		row13<=8'h18;		row14<=8'h00;		row15<=8'h00;
		end
		4'b1010:begin
		row0<=8'h00;		row1<=8'h00;		row2<=8'h00;		row3<=8'h00;
		row4<=8'h00;		row5<=8'h00;		row6<=8'h18;		row7<=8'h18;
		row8<=8'h00;		row9<=8'h00;		row10<=8'h00;		row11<=8'h00;
		row12<=8'h18;		row13<=8'h18;		row14<=8'h00;		row15<=8'h00;
		end
		endcase
	end
end
endmodule
