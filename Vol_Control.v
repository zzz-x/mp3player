`timescale 1ns / 1ps

module VolControl(
    input clk,
    input IncVol,
    input DecVol,
    input PreMusic,
    input NextMusic,
    output [7:0]vol,
    output [7:0]vol_dec,
    output [4:0]music_select,
    output reg is_changed_n
    );

    //寄存器，保存上一个状态，用来检测变化
    reg [7:0]pre_vol=8'h60;
    reg [7:0]pre_vol_dec=8'd10;
    reg [4:0]cur_music=5'b10000;
    
    //需要有延时，否则会导致音量调整失效
    parameter delay_time = 10000000;
    integer  cnt_delay=0;

    always @(negedge clk) begin
        if(cnt_delay==delay_time)begin
            cnt_delay<=0;
            if(IncVol&&pre_vol>0)begin
                pre_vol<=pre_vol-8'h10;
                pre_vol_dec<=pre_vol_dec+8'd1;
            end
            else if(DecVol&&pre_vol<8'hf0)begin
                pre_vol<=pre_vol+8'h10;
                pre_vol_dec<=pre_vol_dec-8'd1;
            end

            //移位操作
            if(PreMusic)begin
                is_changed_n<=1'b0;
                cur_music<={cur_music[0],cur_music[4:1]};
            end
            else if(NextMusic)begin
                is_changed_n<=1'b0;
                cur_music<={cur_music[3:0],cur_music[4]};
            end
            else
                is_changed_n<=1'b1;
        end
        else 
            cnt_delay<=cnt_delay+1;
    end

    assign vol=pre_vol; 
    assign music_select=cur_music;
    assign vol_dec=pre_vol_dec;

endmodule
