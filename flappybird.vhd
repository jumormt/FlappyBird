--------------------------------------
--Design Unit :	��ģ�������
--File Name	  :	flappybird.vhd
--Description :	ʵ�ָ�ģ������Ӳ���
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
	--sw4 ��ͣ���ؽ��루sw���뿪�أ�
	sw7:in std_logic;
	--sw7 ��Ϸ�������ؽ���
	sw6:in std_logic;
	--sw6 ��Ϸģʽ���ؽ���
	sw1:in std_logic;
	--sw1&sw0 �����ٶȿ��ؽ���
	sw0:in std_logic;
	reset:in std_logic;
	--btn7 ���ø�λ�������루btn������
	clk:in std_logic;
	--ʱ�ӽ���
	btn_up:in std_logic;
	--btn0 ���һ���ϰ�������
	btn_down:in std_logic;
	--btn1 ���һ���°�������
	btn_left:in std_logic;
	--btn3 ���һ���󰴼�����
	btn_right:in std_logic;
	--btn2 ���һ���Ұ�������
	btn_up2:in std_logic;
	--btn4 ��Ҷ����ϰ�������
	btn_down2:in std_logic;
	--btn5 ��Ҷ����°�������
	G:out std_logic_vector (7 downto 0);
	--�ܵ�������ʾ�������
	R:out std_logic_vector (7 downto 0);
	--С����ʾ�������
	C:out std_logic_vector (7 downto 0);
	--���������������
	score_view:out std_logic_vector (6 downto 0);
	--����������������
	cat:out std_logic_vector (7 downto 0)
	--����ܹ��������������
	);
end flappybird;

architecture flappy_bird_arc of flappybird is

	--��������ģ��
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

	--���һС���λ�����ģ��
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
		--С���ƶ�ǰ�ĺ���λ��
		position_now_x:out integer range 0 to 7:=4;
		--С���ƶ���ĺ���λ��
		position_past:out integer range 0 to 7:=4;
		--С���ƶ�ǰ������λ��
		position_now:out integer range 0 to 7:=4
		--С���ƶ��������λ��
		);
	end component bird_position;

	--��Ҷ�С���λ�����ģ��
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

	--ģʽѡ��ģ�飨������ģʽ���ٶ�ѡ��
	component mode_select is
		port
		(
		sw7:in std_logic;
		sw6:in std_logic;
		sw1:in std_logic;
		sw0:in std_logic;
		speed_mode:out integer range 0 to 3;
		--�ж��ٶȵĵ������
		speed_mode_view:out integer range 0 to 3;
		--�ж��ٶȵ���������
		member:out std_logic;
		--�ж������ĵ������
		member_view:out integer range 0 to 2;
		--�ж���������������
		more:out std_logic
		--�ж�ģʽ�ĵ������
		);
	end component mode_select;

	--�ܵ���С�񣬵��󹫹����������ĸ����Լ���ײ�жϺͷ�������
	component pipe_move is
		port
		(
		random_out:in integer range 0 to 16;
		member:in std_logic;
		more:in std_logic;
		reset:in std_logic;
		flag_1:in integer range 0 to 28;
		--��¼ʱ��clk3��1hz���ļ�����
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
		--���һ�ķ������
		score2:out integer range 0 to 12;
		--��Ҷ��ķ������
		game_over_clk32:out integer range 0 to 2;
		--��Ҷ�����Ϸ�����ж����
		game_over_clk3:out integer range 0 to 2
		--���һ����Ϸ�����ж����
		);
	end component pipe_move;

	--1000HZ�Ļ�ȡ
	component div_clk is
	port
	  (
	  clk:in std_logic;
	  clk_out:out std_logic
	  );
	end component div_clk;

	--�����������
	component random is
	port
	  (
	    clk:in std_logic;
	    random_out:out integer range 0 to 16
	    --����������
	  );
	end component random;

	--��Ƶ�����ֳ�Ƶ��Ϊ1HZ
	component div_clk3 is
	port
		(
		speed_mode:in integer range 0 to 3;
		clk:in std_logic;
		clk_3:out std_logic
		);
	end component div_clk3;

	--��Ƶ�����ֳ�����Ƶ��
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

	--�������ʾģ��
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

	--*_sig* ��ʾ���Ե��ź���
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
	--ģ��������
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



