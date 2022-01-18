module VGA_Driver (
    input [4:0]music_select,
    input clk_vga,  //65MHZ
    input rst_n,
    input [7:0]vol_dec,
    output[11:0] vga_rgb,
    input[3:0]min_l,
    input[3:0]min_h,
    input[3:0]sec_l,
    input[3:0]sec_h,
    output reg vga_h_sync,    //行同步
    output reg vga_v_sync    //场同步    
 );

parameter H_SYNC  =11'd136;     //行同步
parameter H_BACK  =11'd160;     //行显示后
parameter H_DISP  =11'd1024;    //行有效数
parameter H_FRONT =11'd24;      //行显示前
parameter H_TOTAL =11'd1344;     //总


parameter V_SYNC  =10'd6 ;
parameter V_BACK  =10'd29 ;
parameter V_DISP  =10'd768 ;    
parameter V_FRONT =10'd3 ;
parameter V_TOTAL =10'd806 ;


/***********图片显示**********/
parameter Image_Begin_x =272 ;
parameter Image_Begin_y =30;
parameter IMAGE_H =480;
parameter IMAGE_V =480;

/***********字模显示**********/
integer   Char_Begin_x =50;
parameter Char_Begin_y =640;
parameter Char_Width=512;
parameter Char_Height=64;

/***********时间显示**********/
parameter Time_Begin_x =440;
parameter Time_Begin_y =540;
parameter Time_Width =160;
parameter Time_Height=64;

/********字模偏移量和数据*****/
wire [9:0]char_x;
wire [9:0]char_y;
wire [511:0]char_data[63:0];
wire char_ena;

/**********时间数据**********/
wire [9:0]time_x;
wire [9:0]time_y;
wire[39:0]time_data_sum[15:0];
wire[7:0]time_data_1[15:0];
wire[7:0]time_data_2[15:0];
wire[7:0]time_data_3[15:0];
wire[7:0]time_data_4[15:0];
wire[7:0]time_data_5[15:0];
wire time_ena;

/************音量信息***********/
parameter Vol_Col_Begin_x1 =100;
parameter Vol_Col_Begin_x2 =824;
parameter Vol_Col_Width =100;
parameter Vol_Col_BASE =510 ;
parameter Vol_Per_Height=28;
wire vol_ena;
  

/*******字模数据设置********/
Char_Set inst_charset(
    .music_select(music_select),
    .rst_n(rst_n),
    .row0(char_data[0]),
    .row1(char_data[1]),
    .row2(char_data[2]),
    .row3(char_data[3]),
    .row4(char_data[4]),
    .row5(char_data[5]),
    .row6(char_data[6]),
    .row7(char_data[7]),
    .row8(char_data[8]),
    .row9(char_data[9]),
    .row10(char_data[10]),
    .row11(char_data[11]),
    .row12(char_data[12]),
    .row13(char_data[13]),
    .row14(char_data[14]),
    .row15(char_data[15]),
    .row16(char_data[16]),
    .row17(char_data[17]),
    .row18(char_data[18]),
    .row19(char_data[19]),
    .row20(char_data[20]),
    .row21(char_data[21]),
    .row22(char_data[22]),
    .row23(char_data[23]),
    .row24(char_data[24]),
    .row25(char_data[25]),
    .row26(char_data[26]),
    .row27(char_data[27]),
    .row28(char_data[28]),
    .row29(char_data[29]),
    .row30(char_data[30]),
    .row31(char_data[31]),
    .row32(char_data[32]),
    .row33(char_data[33]),
    .row34(char_data[34]),
    .row35(char_data[35]),
    .row36(char_data[36]),
    .row37(char_data[37]),
    .row38(char_data[38]),
    .row39(char_data[39]),
    .row40(char_data[40]),
    .row41(char_data[41]),
    .row42(char_data[42]),
    .row43(char_data[43]),
    .row44(char_data[44]),
    .row45(char_data[45]),
    .row46(char_data[46]),
    .row47(char_data[47]),
    .row48(char_data[48]),
    .row49(char_data[49]),
    .row50(char_data[50]),
    .row51(char_data[51]),
    .row52(char_data[52]),
    .row53(char_data[53]),
    .row54(char_data[54]),
    .row55(char_data[55]),
    .row56(char_data[56]),
    .row57(char_data[57]),
    .row58(char_data[58]),
    .row59(char_data[59]),
    .row60(char_data[60]),
    .row61(char_data[61]),
    .row62(char_data[62]),
    .row63(char_data[63])
);

/********时间数据读取********/
Time_Set data1(
    .num(sec_l),
    .rst_n(rst_n),
    .row0(time_data_1[0]),.row1(time_data_1[1]),
    .row2(time_data_1[2]),.row3(time_data_1[3]),
    .row4(time_data_1[4]),.row5(time_data_1[5]),
    .row6(time_data_1[6]),.row7(time_data_1[7]),
    .row8(time_data_1[8]),.row9(time_data_1[9]),
    .row10(time_data_1[10]),.row11(time_data_1[11]),
    .row12(time_data_1[12]),.row13(time_data_1[13]),
    .row14(time_data_1[14]),.row15(time_data_1[15])
);
Time_Set data2(
    .num(sec_h),
    .rst_n(rst_n),
    .row0(time_data_2[0]),.row1(time_data_2[1]),
    .row2(time_data_2[2]),.row3(time_data_2[3]),
    .row4(time_data_2[4]),.row5(time_data_2[5]),
    .row6(time_data_2[6]),.row7(time_data_2[7]),
    .row8(time_data_2[8]),.row9(time_data_2[9]),
    .row10(time_data_2[10]),.row11(time_data_2[11]),
    .row12(time_data_2[12]),.row13(time_data_2[13]),
    .row14(time_data_2[14]),.row15(time_data_2[15])
);
Time_Set data3(
    .num(4'b1010),
    .rst_n(rst_n),
    .row0(time_data_3[0]),.row1(time_data_3[1]),
    .row2(time_data_3[2]),.row3(time_data_3[3]),
    .row4(time_data_3[4]),.row5(time_data_3[5]),
    .row6(time_data_3[6]),.row7(time_data_3[7]),
    .row8(time_data_3[8]),.row9(time_data_3[9]),
    .row10(time_data_3[10]),.row11(time_data_3[11]),
    .row12(time_data_3[12]),.row13(time_data_3[13]),
    .row14(time_data_3[14]),.row15(time_data_3[15])
);
Time_Set data4(
    .num(min_l),
    .rst_n(rst_n),
    .row0(time_data_4[0]),.row1(time_data_4[1]),
    .row2(time_data_4[2]),.row3(time_data_4[3]),
    .row4(time_data_4[4]),.row5(time_data_4[5]),
    .row6(time_data_4[6]),.row7(time_data_4[7]),
    .row8(time_data_4[8]),.row9(time_data_4[9]),
    .row10(time_data_4[10]),.row11(time_data_4[11]),
    .row12(time_data_4[12]),.row13(time_data_4[13]),
    .row14(time_data_4[14]),.row15(time_data_4[15])
);
Time_Set data5(
    .num(min_h),
    .rst_n(rst_n),
    .row0(time_data_5[0]),.row1(time_data_5[1]),
    .row2(time_data_5[2]),.row3(time_data_5[3]),
    .row4(time_data_5[4]),.row5(time_data_5[5]),
    .row6(time_data_5[6]),.row7(time_data_5[7]),
    .row8(time_data_5[8]),.row9(time_data_5[9]),
    .row10(time_data_5[10]),.row11(time_data_5[11]),
    .row12(time_data_5[12]),.row13(time_data_5[13]),
    .row14(time_data_5[14]),.row15(time_data_5[15])
);


assign time_data_sum[0]={time_data_5[0],time_data_4[0],time_data_3[0],time_data_2[0],time_data_1[0]};
assign time_data_sum[1]={time_data_5[1],time_data_4[1],time_data_3[1],time_data_2[1],time_data_1[1]};
assign time_data_sum[2]={time_data_5[2],time_data_4[2],time_data_3[2],time_data_2[2],time_data_1[2]};
assign time_data_sum[3]={time_data_5[3],time_data_4[3],time_data_3[3],time_data_2[3],time_data_1[3]};
assign time_data_sum[4]={time_data_5[4],time_data_4[4],time_data_3[4],time_data_2[4],time_data_1[4]};
assign time_data_sum[5]={time_data_5[5],time_data_4[5],time_data_3[5],time_data_2[5],time_data_1[5]};
assign time_data_sum[6]={time_data_5[6],time_data_4[6],time_data_3[6],time_data_2[6],time_data_1[6]};
assign time_data_sum[7]={time_data_5[7],time_data_4[7],time_data_3[7],time_data_2[7],time_data_1[7]};
assign time_data_sum[8]={time_data_5[8],time_data_4[8],time_data_3[8],time_data_2[8],time_data_1[8]};
assign time_data_sum[9]={time_data_5[9],time_data_4[9],time_data_3[9],time_data_2[9],time_data_1[9]};
assign time_data_sum[10]={time_data_5[10],time_data_4[10],time_data_3[10],time_data_2[10],time_data_1[10]};
assign time_data_sum[11]={time_data_5[11],time_data_4[11],time_data_3[11],time_data_2[11],time_data_1[11]};
assign time_data_sum[12]={time_data_5[12],time_data_4[12],time_data_3[12],time_data_2[12],time_data_1[12]};
assign time_data_sum[13]={time_data_5[13],time_data_4[13],time_data_3[13],time_data_2[13],time_data_1[13]};
assign time_data_sum[14]={time_data_5[14],time_data_4[14],time_data_3[14],time_data_2[14],time_data_1[14]};
assign time_data_sum[15]={time_data_5[15],time_data_4[15],time_data_3[15],time_data_2[15],time_data_1[15]};

/***********行列计数************/
reg[10:0]h_cnt;
reg[10:0]v_cnt;
wire image_ena;

/***********Rom取值************/
reg [18:0]ADR;
reg [4:0]cur_music;

/**********时间字模************/
assign time_ena=(h_cnt-H_SYNC-H_BACK>Time_Begin_x)&&(h_cnt-H_SYNC-H_BACK-Time_Begin_x<Time_Width)&&(v_cnt-V_SYNC-V_BACK>Time_Begin_y)&&(v_cnt-V_SYNC-V_BACK-Time_Begin_y<Time_Height);
assign time_x=h_cnt-H_SYNC-H_BACK-Time_Begin_x;
assign time_y=v_cnt-V_SYNC-V_BACK-Time_Begin_y;

/**********音量设置***********/
assign vol_ena=(((h_cnt>H_SYNC+H_BACK+Vol_Col_Begin_x1)&&(h_cnt<H_SYNC+H_BACK+Vol_Col_Begin_x1+Vol_Col_Width))
        ||((h_cnt>H_SYNC+H_BACK+Vol_Col_Begin_x2)&&(h_cnt<H_SYNC+H_BACK+Vol_Col_Begin_x2+Vol_Col_Width)))
        &&(v_cnt>V_SYNC+V_BACK+Vol_Col_BASE-Vol_Per_Height*vol_dec)&&(v_cnt<V_SYNC+V_BACK+Vol_Col_BASE);

/*********字模数据相对偏移量*************/
assign char_ena=(h_cnt>H_SYNC+H_BACK+Char_Begin_x)&&(h_cnt<=H_SYNC+H_BACK+Char_Begin_x+Char_Width)&&
                (v_cnt>V_SYNC+V_BACK+Char_Begin_y)&&(v_cnt<=V_SYNC+V_BACK+Char_Begin_y+Char_Height);
assign char_x= (h_cnt-H_SYNC-H_BACK-Char_Begin_x)>=0?(h_cnt-H_SYNC-H_BACK-Char_Begin_x):(H_DISP+h_cnt-H_SYNC-H_BACK-Char_Begin_x);
assign char_y= v_cnt-H_SYNC-H_BACK-Char_Begin_y;

always @(posedge clk_vga) begin
    if(!rst_n)begin
        cur_music<=music_select;
    end
    else if(cur_music!=music_select)begin
        cur_music<=music_select;
    end
end

always @(posedge clk_vga) begin
    //if(!rst_n||cur_music!=music_select)
    if(!rst_n)
        h_cnt<=0;
    else if(h_cnt<H_TOTAL-1'b1)
        h_cnt<=h_cnt+1'b1;
    else
        h_cnt<=0;
end

always @(posedge clk_vga) begin
    //if(!rst_n||cur_music!=music_select)
    if(!rst_n)
        v_cnt<=0;
    else if(h_cnt==H_TOTAL-1'b1)begin
        if(v_cnt<V_TOTAL-1'b1)
            v_cnt<=v_cnt+1'b1;
        else begin
            v_cnt<=0;
            if(Char_Begin_x+Char_Width>0)
                Char_Begin_x<=Char_Begin_x-1;
            else
                Char_Begin_x<=1000;
        end
    end
end

always @(posedge clk_vga ) begin
    //if(!rst_n||cur_music!=music_select)
    if(!rst_n)
        vga_h_sync<=1'b1;
    else if(h_cnt>=0&&h_cnt<H_SYNC)
        vga_h_sync<=1'b0;
    else
        vga_h_sync<=1'b1;
end

always @(posedge clk_vga) begin
    //if(!rst_n||cur_music!=music_select)
    if(!rst_n)
        vga_v_sync<=1'b1;
    else if(v_cnt>=0&&v_cnt<V_SYNC)
        vga_v_sync<=0;
    else
        vga_v_sync<=1'b1;
end


assign image_ena=(h_cnt>=H_SYNC+H_BACK+Image_Begin_x)&&(h_cnt<H_SYNC+H_BACK+Image_Begin_x+IMAGE_H)&&(v_cnt>=V_SYNC+V_BACK+Image_Begin_y)&&(v_cnt<V_SYNC+V_BACK+Image_Begin_y+IMAGE_V)&&(rst_n);

always @(posedge clk_vga) begin
    if(!rst_n||cur_music!=music_select)
        ADR=0;
    else if(h_cnt==0&&v_cnt==0)
        //ADR=1;
        ADR=0;
    else if(image_ena)begin
        //ADR=(ADR+1);
        ADR=(v_cnt-V_SYNC-V_BACK-Image_Begin_y)/2*240+(h_cnt-H_SYNC-H_BACK-Image_Begin_x)/2;
    end
    else if(ADR==(IMAGE_H*IMAGE_V)/4-1)
        ADR=0;
end

wire [11:0]image_data[4:0];
wire [11:0]douta;
reg [11:0]tmp_rgb;

//先图片，再音量，最后字模
always @(posedge clk_vga) begin
    if(image_ena)
        tmp_rgb<=douta;
    else if(h_cnt<H_SYNC+H_BACK||h_cnt>H_SYNC+H_BACK+H_DISP||v_cnt<V_SYNC+V_BACK||v_cnt>V_SYNC+V_BACK+V_DISP)
        tmp_rgb<=0;
    else if(time_ena&&time_data_sum[time_y/4][10'd39-time_x/4])
            tmp_rgb<=12'b0;
    else if(vol_ena)
        tmp_rgb<=12'b0000_1111_0000;
    else if(char_ena&&char_data[char_y][10'd511-char_x])
        tmp_rgb<=12'b1111_0000_1111;
    else
        tmp_rgb<=12'b1111_1111_1111;
end

assign vga_rgb=tmp_rgb;

/**********ROM数据获取**************/
blk_mem_gen_0_pic getData0(.clka(clk_vga),.ena(1),.addra(ADR),.douta(image_data[0]));
blk_mem_gen_1_pic getData1(.clka(clk_vga),.ena(1),.addra(ADR),.douta(image_data[1]));
blk_mem_gen_2_pic getData2(.clka(clk_vga),.ena(1),.addra(ADR),.douta(image_data[2]));
blk_mem_gen_3_pic getData3(.clka(clk_vga),.ena(1),.addra(ADR),.douta(image_data[3]));
blk_mem_gen_4_pic getData4(.clka(clk_vga),.ena(1),.addra(ADR),.douta(image_data[4]));

/************5选1数据选择器*********/
selector51 select_img(
        .data0(image_data[0]),
        .data1(image_data[1]),
        .data2(image_data[2]),
        .data3(image_data[3]),
        .data4(image_data[4]),
        .select_msg(music_select),
        .oData(douta)
    );

endmodule

