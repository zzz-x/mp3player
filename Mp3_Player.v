`timescale 1ns / 1ps


module selector51(
    input[15:0] data0,
    input[15:0] data1,
    input[15:0] data2,
    input[15:0] data3,
    input[15:0] data4,
    input[4:0]select_msg,
    output reg [15:0] oData
);
always @(*) begin
    if(select_msg==5'b00001)
        oData=data0;
    else if(select_msg==5'b00010)
        oData=data1;
    else if(select_msg==5'b00100)
        oData=data2;
    else if(select_msg==5'b01000)
        oData=data3;
    else if(select_msg==5'b10000)
        oData=data4;
end
endmodule

module Divider_Mp3 #(parameter Time=20)
(
    input I_CLK,
    output reg O_CLK
);
    integer counter=0;
    initial O_CLK = 0;
    always @ (posedge I_CLK)
    begin
        if((counter+1)==Time/2)
        begin
            counter <= 0;
            O_CLK <= ~O_CLK;
        end
        else
            counter <= counter+1;
    end
endmodule

module mp3_player (
    input [7:0]vol,
    input [4:0]music_select,
    input CLK,
    input DREQ,
    input RST,
    output reg XDCS,    //data
    output reg XCS,     //cmd
    output reg SI,
    output reg SCLK,
    output reg XRESET,
    
    //add
    output reg DEBUG
);

    wire clk_div;
    //分频
    Divider_Mp3 #(.Time(100)) div(CLK,clk_div);    
    reg[3:0] STATE;

    wire [15:0]douta;
    reg  [15:0]addr=0;
    reg  [15:0]buffer;

    wire [15:0]RomData[4:0];
    

    //ip核获取音频数据
    blk_mem_gen_0 music0(.clka(CLK),.ena(music_select[0]),.addra(addr),.douta(RomData[0]));         //夜曲
    blk_mem_gen_1 music1(.clka(CLK),.ena(music_select[1]),.addra(addr),.douta(RomData[1]));         //七里香
    blk_mem_gen_2 music2(.clka(CLK),.ena(music_select[2]),.addra(addr),.douta(RomData[2]));         //安静
    blk_mem_gen_3 music3(.clka(CLK),.ena(music_select[3]),.addra(addr),.douta(RomData[3]));         //轨迹
    blk_mem_gen_4 music4(.clka(CLK),.ena(music_select[4]),.addra(addr),.douta(RomData[4]));         //一路向北
    
    //通过数据选择器，从5个数据中选择
    selector51 select_music(
        .data0(RomData[0]),
        .data1(RomData[1]),
        .data2(RomData[2]),
        .data3(RomData[3]),
        .data4(RomData[4]),
        .select_msg(music_select),
        .oData(douta)
    );

    parameter MAX_DELAY =16600 ;
    integer  delay;

    integer cmd_cnt;
    integer data_cnt;       //计数
    reg[31:0]sci_cmd;       //sci命令
    reg[7:0]cur_vol;        //音量
    reg[4:0]cur_music;      //当前音乐


    /**********状态机定义************/
    parameter WAITING  =4'd0 ;
    parameter H_RESET  =4'd1 ;
    parameter S_RESET  =4'd2 ;
    parameter SET_VOL  =4'd3;
    parameter LOAD_DATA=4'd4;
    parameter PLAY     =4'd5 ;

    assign music_data=douta;
    
    always @(posedge clk_div) begin
        if(!RST)begin
            XRESET<=1'b0;
            XCS<=1'b1;
            XDCS<=1'b1;
            delay<=0;
            addr<=0;
            DEBUG<=1'b0;
            STATE<=WAITING;
            cur_vol<=vol;
            cur_music<=music_select;
        end
        else if(music_select!=cur_music)begin
            cur_music<=music_select;
            XRESET<=1'b0;
            XCS<=1'b1;
            XDCS<=1'b1;
            delay<=0;
            addr<=0;
            DEBUG<=1'b0;
            cur_vol<=vol;
            STATE<=WAITING;
        end
        else begin
            case(STATE)
                /**********等待状态*******/
                WAITING:begin
                    SCLK<=0;
                    if(delay==MAX_DELAY)begin
                        STATE<=H_RESET;
                        cmd_cnt<=0;
                        XRESET<=1'b1;
                        delay<=0;
                    end
                    else
                        delay<=delay+1;
                end
                /*********硬件复位********/
                H_RESET:begin                    
                    cmd_cnt<=0;
                    XCS<=1'b1;
                    STATE<=S_RESET;
                    sci_cmd<=32'h02000804;
                    SCLK<=1'b0;  
                end
                /********软复位**********/
                S_RESET:begin
                    if(DREQ)begin
                        if(SCLK)begin
                            if(cmd_cnt==32)begin
                                cmd_cnt<=0;
                                XCS<=1'b1;
                                STATE<=SET_VOL;
                                sci_cmd<={16'h020b,vol,vol};
                            end
                            else begin
                                XCS<=1'b0;
                                SI<=sci_cmd[31];
                                sci_cmd<={sci_cmd[30:0],sci_cmd[31]};
                                cmd_cnt<=cmd_cnt+1'b1;
                            end
                        end
                    end
                    SCLK<=~SCLK;
                end

              /*********音量控制**********/
                SET_VOL:begin
                    if(DREQ)begin
                        if(SCLK)begin
                            if(cmd_cnt==32)begin
                                cmd_cnt<=0;
                                XCS<=1'b1;
                                STATE<=LOAD_DATA;
                            end
                            else begin
                                XCS<=0;
                                SI<=sci_cmd[31] ;
                                sci_cmd<={sci_cmd[30:0],sci_cmd[31]};
                                cmd_cnt<=cmd_cnt+1'b1;
                            end
                        end
                    end
                    SCLK<=~SCLK;
                end
                /********数据装载，可跳转至音量控制*********/
                LOAD_DATA:begin
                    if(cur_vol!=vol)begin
                        cur_vol<=vol;
                        cmd_cnt<=0;
                        STATE<=SET_VOL;
                        sci_cmd<={16'h020b,vol,vol};
                        XCS<=1'b1;
                    end
                    else if(DREQ)begin
                        SCLK<=0;
                        STATE<=PLAY;
                        buffer<=douta;
                        data_cnt<=0;
                    end
                end
                /*******传输数据并播放*********/
                PLAY:begin
                    if(SCLK)begin
                        if(data_cnt==16)begin
                            XDCS<=1'b1;
                            addr<=addr+1'b1;
                            STATE<=LOAD_DATA;
                        end
                        else begin
                            XDCS<=1'b0;
                            SI<=buffer[15];
                            buffer<={buffer[14:0],buffer[15]};
                            data_cnt<=data_cnt+1;
                        end
                    end
                    SCLK=~SCLK;
                end
            endcase
        end
    end
endmodule