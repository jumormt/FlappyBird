------------------------------------------
--Design Unit :	С�����������
--File Name	  :	bird_position.vhd
--Description :	ʵ�����һС������������
--Limitations :	none
--System	  :	VHDL 93
--Author      :	Xiao Cheng
--Revision	  :	Version 1.0 2016-10-26
-------------------------------------------
--��������ӿ����ý��Ͳο��ļ�flappybird.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bird_position is
	port
	(
	reset:in std_logic;
	clk_1:in std_logic;
	btn_up:in std_logic;
	--����
	btn_down:in std_logic;
	--����
	btn_left:in std_logic;
	--����
	btn_right:in std_logic;
	--����
	position_past_x:out integer range 0 to 7:=4;
	position_now_x:out integer range 0 to 7:=4;
	position_past:out integer range 0 to 7:=4;
	position_now:out integer range 0 to 7:=4
	);
end bird_position;

architecture bird_position_arc of bird_position is
	signal position_p:integer range 0 to 7:=4;
	--������������ź���
	signal position_n:integer range 0 to 7:=4;
	--������������ź���
	signal position_p_x:integer range 0 to 7:=4;
	--������������ź���
	signal position_n_x:integer range 0 to 7:=4;
	--���ֺ�������ź���
begin
	p:process(btn_up,btn_down)
	begin
		--��λ
		if reset = '1' then
			position_p_x <= 4;
			position_n_x <= 4;
			position_past_x <= position_p_x;
			position_now_x <= position_n_x;
			position_n <= 4;
			position_past <= position_p;
			position_now <= position_n;
		else
			--�����ж�
			if clk_1'event and clk_1 = '1' and btn_up = '1' then
				if position_n = 7 then position_n <= 7;position_p <= 6;
				else position_p <= position_n;position_n <= position_n+1;
				end if;
			end if;

			--�½��ж�
			if clk_1'event and clk_1 = '1' and  btn_down = '1' then
				if position_n = 0 then position_n <= 0;position_p <= 1;
				else position_p <= position_n;position_n <= position_n-1;
				end if;
			end if;

			--�����ж�
			if clk_1'event and clk_1 = '1' and  btn_left = '1' then
				if position_n_x = 0 then position_n_x <= 0;position_p_x <= 1;
				else position_p_x <= position_n_x;position_n_x <= position_n_x-1;
				end if;
			end if;

			--�����ж�
			if clk_1'event and clk_1 = '1' and  btn_right = '1' then
				if position_n_x = 7 then position_n_x <= 7;position_p_x <= 1;
				else position_p_x <= position_n_x;position_n_x <= position_n_x+1;
				end if;
			end if;

			position_past <= position_p;
			position_now <= position_n;
			position_past_x <= position_p_x;
			position_now_x <= position_n_x;
		end if;
	end process p;
end bird_position_arc;



