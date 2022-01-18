module Bluetooth (
    input Bluetooth_clk,
    input rst_n,
    input data_in,
    output Bt_Inc_Vol,
    output Bt_Dec_Vol,
    output Bt_Next_Song,
    output Bt_Pre_Song,
    output Bt_Rst 
);

wire [7:0]data_out;
UART inst_uart(
    .uart_clk(Bluetooth_clk),
    .data_in(data_in),
    .rst_n(rst_n),
    .data_out(data_out)
    );

assign  Bt_Dec_Vol   = (data_out==8'hb0)?1'b1:1'b0;
assign  Bt_Inc_Vol   = (data_out==8'hb1)?1'b1:1'b0;
assign  Bt_Next_Song = (data_out==8'hb2)?1'b1:1'b0;
assign  Bt_Pre_Song  = (data_out==8'hb3)?1'b1:1'b0;
assign  Bt_Rst       = (data_out==8'hb4)?1'b0:1'b1;



    
endmodule