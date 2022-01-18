`timescale 1ns / 1ps

module TOP(
    input IncVol,
    input DecVol,
    input NextSong,
    input PreSong,
    
    input CLK,
    input RST,

    /***********mp3***********/
    input DREQ,
    output  XDCS,    //data
    output  XCS,     //cmd
    output  SI,
    output  SCLK,
    output  XRESET,


    /***********VGA***********/
    output vga_h_sync,
    output vga_v_sync,
    output [11:0]vga_rgb,

    /**********Bluetooth***********/
    input RXD,
    output Bt_Inc_Vol,
    output Bt_Dec_Vol, 
    output Bt_Rst,
    output Bt_Next_Song,
    output Bt_Pre_Song,

    /***********调试按钮***********/
    output DEBUG

);
    //三个时钟
    wire clk_65;
    wire clk_12;
    wire clk_1s;

    //音量、歌曲控制
    wire[7:0]vol;
    wire[4:0]music_select;
    wire[7:0]vol_dec;
    wire is_changed_n;
    
    //时间，秒，分
    wire [3:0]sec_l;
    wire [3:0]sec_h;
    wire [3:0]min_l;
    wire [3:0]min_h;
    
    
    /***********时钟IP核*******/
    clk_wiz_1 div65(.clk_in1(CLK),.clk_65(clk_65),.clk_12(clk_12),.reset(0));

    /************蓝牙模块*********/
    Bluetooth inst_bluetooth(
        .Bluetooth_clk(CLK),
        .rst_n(RST),
        .data_in(RXD),
        .Bt_Dec_Vol(Bt_Dec_Vol),
        .Bt_Inc_Vol(Bt_Inc_Vol),
        .Bt_Rst(Bt_Rst),
        .Bt_Pre_Song(Bt_Pre_Song),
        .Bt_Next_Song(Bt_Next_Song)
    );

    /****板载控制与蓝牙控制处理****/
    wire control_RST=RST&&Bt_Rst;
    wire control_Vol_inc=IncVol|Bt_Inc_Vol;
    wire control_Vol_dec=DecVol|Bt_Dec_Vol;
    wire control_Song_nex=NextSong|Bt_Next_Song;
    wire control_Song_pre=PreSong|Bt_Pre_Song;

    /**********控制模块************/
    VolControl uut(
        .clk(CLK),
        .IncVol(control_Vol_inc),
        .DecVol(control_Vol_dec),
        .NextMusic(control_Song_nex),
        .PreMusic(control_Song_pre),
        .vol_dec(vol_dec),
        .is_changed_n(is_changed_n),
        .music_select(music_select),
        .vol(vol)
    );


    /**********音乐播放************/
    mp3_player myplayer(
        .vol(vol),
        .music_select(music_select),
        .CLK(CLK),
        .DREQ(DREQ),
        .RST(control_RST),
        .XDCS(XDCS),
        .XCS(XCS),
        .SI(SI),
        .SCLK(SCLK),
        .XRESET(XRESET),
        .DEBUG(DEBUG)
    );
    
   

    /**********VGA显示图片************/
   VGA_Driver vga_ins(
       .music_select(music_select),
       .clk_vga(clk_65),
       .rst_n(control_RST),
       .min_h(min_h),
       .min_l(min_l),
       .sec_h(sec_h),
       .sec_l(sec_l),
       .vga_rgb(vga_rgb),
       .vol_dec(vol_dec),
       .vga_h_sync(vga_h_sync),
       .vga_v_sync(vga_v_sync)
    );
    //分频器，时钟周期为1s
    divider1 div1s(.clk(CLK),.clk_1(clk_1s));
    
    wire time_rst=control_RST&&is_changed_n;
    TimeDeal record(.clk(clk_1s),.rst_n(time_rst),.sec_l(sec_l),.sec_h(sec_h),.min_l(min_l),.min_h(min_h));
  
    
endmodule
