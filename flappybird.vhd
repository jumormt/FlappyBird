--------------------------------------
--Design Unit :	各模块的链接
--File Name	  :	flappybird.vhd
--Description :	实现各模块的链接操作
--Limitations : none
--System	  :	VHDL 93
--Author	  :	Xiao Cheng
--Revision	  : Version 1.0 2016-10-26
---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity flappybird is
port
	(
	pause:in std_logic;
	--sw4 暂停开关接入（sw拨码开关）
	sw7:in std_logic;
	--sw7 游戏人数开关接入
	sw6:in std_logic;
	--sw6 游戏模式开关接入
	sw1:in std_logic;
	--sw1&sw0 控制速度开关接入
	sw0:in std_logic;
	reset:in std_logic;
	--btn7 重置复位按键接入（btn按键）
	clk:in std_logic;
	--时钟接入
	btn_up:in std_logic;
	--btn0 玩家一向上按键接入
	btn_down:in std_logic;
	--btn1 玩家一向下按键接入
	btn_left:in std_logic;
	--btn3 玩家一向左按键接入
	btn_right:in std_logic;
	--btn2 玩家一向右按键接入
	btn_up2:in std_logic;
	--btn4 玩家二向上按键接入
	btn_down2:in std_logic;
	--btn5 玩家二向下按键接入
	G:out std_logic_vector (7 downto 0);
	--管道点阵显示向量输出
	R:out std_logic_vector (7 downto 0);
	--小鸟显示向量输出
	C:out std_logic_vector (7 downto 0);
	--公共阴极向量输出
	score_view:out std_logic_vector (6 downto 0);
	--数码管阳极向量输出
	cat:out std_logic_vector (7 downto 0)
	--数码管公共阴极向量输出
	);
end flappybird;

architecture flappy_bird_arc of flappybird is

	--按键防抖模块
	component cleanbtn is
		port(
			clk_1: in std_logic;
			btn_up: in std_logic;
			btn_up_out: out std_logic;
			btn_down: in std_logic;
			btn_down_out: out std_logic;
			btn_left: in std_logic;
			btn_left_out: out std_logic;
			btn_right: in std_logic;
			btn_right_out: out std_logic;
			btn_up2: in std_logic;
			btn_up_out2: out std_logic;
			btn_down2: in std_logic;
			btn_down_out2: out std_logic;
			reset: in std_logic;
			reset_out: out std_logic
			);
	end component cleanbtn;

	--玩家一小鸟的位置输出模块
	component bird_position is
		port
		(
		reset:in std_logic;
		clk_1:in std_logic;
		btn_up:in std_logic;
		btn_down:in std_logic;
		btn_left:in std_logic;
		btn_right:in std_logic;
		position_past_x:out integer range 0 to 7:=4;
		--小鸟移动前的横向位置
		position_now_x:out integer range 0 to 7:=4;
		--小鸟移动后的横向位置
		position_past:out integer range 0 to 7:=4;
		--小鸟移动前的纵向位置
		position_now:out integer range 0 to 7:=4
		--小鸟移动后的纵向位置
		);
	end component bird_position;

	--玩家二小鸟的位置输出模块
	component bird_position2 is
		port
		(
		reset:in std_logic;
		clk_1:in std_logic;
		btn_up2:in std_logic;
		btn_down2:in std_logic;
		position_past2:out integer range 0 to 7:=5;
		position_now2:out integer range 0 to 7:=5
		);
	end component bird_position2;

	--模式选择模块（人数，模式，速度选择）
	component mode_select is
		port
		(
		sw7:in std_logic;
		sw6:in std_logic;
		sw1:in std_logic;
		sw0:in std_logic;
		speed_mode:out integer range 0 to 3;
		--判断速度的点阵输出
		speed_mode_view:out integer range 0 to 3;
		--判断速度的数码管输出
		member:out std_logic;
		--判断人数的点阵输出
		member_view:out integer range 0 to 2;
		--判断人数的数码管输出
		more:out std_logic
		--判断模式的点阵输出
		);
	end component mode_select;

	--管道，小鸟，点阵公共阴极向量的更新以及碰撞判断和分数更新
	component pipe_move is
		port
		(
		random_out:in integer range 0 to 16;
		member:in std_logic;
		more:in std_logic;
		reset:in std_logic;
		flag_1:in integer range 0 to 28;
		--记录时钟clk3（1hz）的计数器
		clk_2:in std_logic;
		position_past:in integer range 0 to 7:=4;
		position_now:in integer range 0 to 7:=4;
		position_past_x:in integer range 0 to 7:=4;
		position_now_x:in integer range 0 to 7:=4;
		position_past2:in integer range 0 to 7:=4;
		position_now2:in integer range 0 to 7:=4;
		G:out std_logic_vector (7 downto 0);
		R:out std_logic_vector (7 downto 0);
		C:out std_logic_vector (7 downto 0);
		score:out integer range 0 to 12;
		--玩家一的分数输出
		score2:out integer range 0 to 12;
		--玩家二的分数输出
		game_over_clk32:out integer range 0 to 2;
		--玩家二的游戏结束判断输出
		game_over_clk3:out integer range 0 to 2
		--玩家一的游戏结束判断输出
		);
	end component pipe_move;

	--1000HZ的获取
	component div_clk is
	port
	  (
	  clk:in std_logic;
	  clk_out:out std_logic
	  );
	end component div_clk;

	--随机数发生器
	component random is
	port
	  (
	    clk:in std_logic;
	    random_out:out integer range 0 to 16
	    --随机数的输出
	  );
	end component random;

	--分频器，分出频率为1HZ
	component div_clk3 is
	port
		(
		speed_mode:in integer range 0 to 3;
		clk:in std_logic;
		clk_3:out std_logic
		);
	end component div_clk3;

	--分频器，分出按键频率
	component div_clk1 is
	port
		(
		clk:in std_logic;
		clk_1:out std_logic;
		clk_12:out std_logic
		);
	end component div_clk1;

	component clk_3 is
		port
		(
		pause:in std_logic;
		reset:in std_logic;
		clk_3:in std_logic;
		game_over_clk3:in integer range 0 to 2;
		game_over_clk32:in integer range 0 to 2;
		flag_1:out integer range 0 to 28
		);
	end component clk_3;

	--数码管显示模块
	component seg7_1 is
	port
		(
		 clk_2:in std_logic;
		 score:in integer range 0 to 12;
		 score2:in integer range 0 to 12;
		 speed_mode_view:in integer range 0 to 3;
		 score_view:out std_logic_vector (6 downto 0);
		 member_view:in integer range 0 to 2;
		 cat:out std_logic_vector (7 downto 0)
		);
	end component seg7_1;

	--*_sig* 表示各自的信号量
	signal clk_out_sig:std_logic;
	signal clk_3_sig1:std_logic;
	signal flag_1_sig2:integer range 0 to 28;
	signal game_over_clk3_sig3:integer range 0 to 2;
	signal game_over_clk32_sig3:integer range 0 to 2;
	signal clk_1_sig7:std_logic;
	signal position_past_sig8:integer range 0 to 7;
	signal position_past2_sig8:integer range 0 to 7;
	signal postion_past_x_sig:integer range 0 to 7;
	signal postion_now_x_sig:integer range 0 to 7;
	signal position_now_sig10:integer range 0 to 7;
	signal position_now2_sig10:integer range 0 to 7;
	signal score_sig13:integer range 0 to 12;
	signal score2_sig13:integer range 0 to 12;
	signal clk_4_sig15:std_logic;
	signal speed_mode_sig:integer range 0 to 3;
	signal speed_mode_view_sig:integer range 0 to 3;
	signal member_sig:std_logic;
	signal more_sig:std_logic;
	signal clk_12_sig:std_logic;
	signal memberv_sig:integer range 0 to 2;
	signal clk4_sig:std_logic;
	signal random_out_sig:integer range 0 to 16;
	signal btn_up_sig:std_logic;
	signal btn_down_sig:std_logic;
	signal btn_up_sig2:std_logic;
	signal btn_down_sig2:std_logic;
	signal btn_left_sig:std_logic;
	signal btn_right_sig:std_logic;
	signal reset_sig:std_logic;


begin
	--模块间的连接
	u0:div_clk port map (clk,clk_out_sig);
	u1:div_clk3 port map(speed_mode_sig,clk_out_sig,clk_3_sig1);
	u2:clk_3 port map(pause,reset_sig,clk_3_sig1,game_over_clk3_sig3,game_over_clk32_sig3,flag_1_sig2);
	u3:pipe_move port map(random_out_sig,member_sig,more_sig,reset_sig,flag_1_sig2,clk_out_sig,position_past_sig8,position_now_sig10,postion_past_x_sig,postion_now_x_sig,position_past2_sig8,position_now2_sig10,G,R,C,score_sig13,score2_sig13,game_over_clk32_sig3,game_over_clk3_sig3);
	u4:div_clk1 port map(clk_out_sig,clk_1_sig7,clk_12_sig);
	u5:bird_position port map(reset_sig,clk_1_sig7,btn_up_sig,btn_down_sig, btn_left_sig, btn_right_sig,postion_past_x_sig,postion_now_x_sig,position_past_sig8, position_now_sig10);
	u6:seg7_1 port map(clk_out_sig,score_sig13,score2_sig13,speed_mode_view_sig,score_view,memberv_sig,cat);
	u7:mode_select port map(sw7,sw6,sw1,sw0,speed_mode_sig,speed_mode_view_sig,member_sig,memberv_sig,more_sig);
	u8:bird_position2 port map(reset_sig,clk_12_sig,btn_up_sig2,btn_down_sig2, position_past2_sig8, position_now2_sig10);
	u9:random port map(clk,random_out_sig);
	u10:cleanbtn port map(clk_out_sig,btn_up,btn_up_sig,btn_down,btn_down_sig,btn_left,btn_left_sig,btn_right,btn_right_sig,btn_up2,btn_up_sig2,btn_down2,btn_down_sig2,reset,reset_sig);
end flappy_bird_arc;



