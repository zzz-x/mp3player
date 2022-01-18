module UART (
    input uart_clk,
    input rst_n,
    input data_in,
    output reg [7:0]data_out
);
parameter bps =10417 ;      //9600
reg[15:0] cnt0; //波特率计数
reg[3:0]  cnt1; //数据位计数

reg detect_edge_0,detect_edge_1,detect_edge_2;
wire posedge_state;
reg uart_state;

/*****************检测下降***********************/
always @(posedge uart_clk ) begin
    if(!rst_n)begin
        detect_edge_0<=1;
        detect_edge_1<=1;
        detect_edge_2<=1;
    end
    else begin
        detect_edge_0<=data_in;
        detect_edge_1<=detect_edge_0;
        detect_edge_2<=detect_edge_1;
    end
end

assign posedge_state=~detect_edge_1&detect_edge_2;//是否是上升沿

/*******************波特率计数*******************/
always @(posedge uart_clk) begin
    if(!rst_n)
        cnt0<=0;
    else if(uart_state)begin
        if(cnt0==bps-1'b1)
            cnt0<=0;
        else
            cnt0<=cnt0+1'b1;
    end
end

/********************数据计数************************/
always @(posedge uart_clk ) begin
    if(!rst_n)
        cnt1<=0;
    else if(uart_state&&cnt0==bps-1'b1)begin
        if(cnt1==4'd8)
            cnt1<=0;
        else
            cnt1<=cnt1+1'b1;
    end
end

/**********状态调整***************/
always @ (posedge uart_clk)begin
    if(!rst_n)begin
        uart_state<=0;
    end
    else if(posedge_state)
        uart_state<=1;
    else if(uart_state&&cnt1==8&&cnt0==bps-1)
        uart_state<=0;
end

/************数据读取***********/
always @(posedge uart_clk) begin
    if(!rst_n)begin
        data_out<=0;
    end
    else if(uart_state&&cnt0==bps/2-1&&cnt1!=0)begin
        data_out[cnt1-1]<=data_in;
    end
end

endmodule