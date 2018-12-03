------------------------------------------
--Design Unit :	小鸟纵坐标输出
--File Name	  :	bird_position.vhd
--Description :	实现玩家一小鸟纵坐标的输出
--Limitations :	none
--System	  :	VHDL 93
--Author      :	Xiao Cheng
--Revision	  :	Version 1.0 2016-10-26
-------------------------------------------
--输入输出接口设置解释参考文件flappybird.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bird_position is
	port
	(
	reset:in std_logic;
	clk_1:in std_logic;
	btn_up:in std_logic;
	--向上
	btn_down:in std_logic;
	--向下
	btn_left:in std_logic;
	--向左
	btn_right:in std_logic;
	--向右
	position_past_x:out integer range 0 to 7:=4;
	position_now_x:out integer range 0 to 7:=4;
	position_past:out integer range 0 to 7:=4;
	position_now:out integer range 0 to 7:=4
	);
end bird_position;

architecture bird_position_arc of bird_position is
	signal position_p:integer range 0 to 7:=4;
	--鸟往纵坐标的信号量
	signal position_n:integer range 0 to 7:=4;
	--鸟现纵坐标的信号量
	signal position_p_x:integer range 0 to 7:=4;
	--鸟往横坐标的信号量
	signal position_n_x:integer range 0 to 7:=4;
	--鸟现横坐标的信号量
begin
	p:process(btn_up,btn_down)
	begin
		--复位
		if reset = '1' then
			position_p_x <= 4;
			position_n_x <= 4;
			position_past_x <= position_p_x;
			position_now_x <= position_n_x;
			position_n <= 4;
			position_past <= position_p;
			position_now <= position_n;
		else
			--上升判断
			if clk_1'event and clk_1 = '1' and btn_up = '1' then
				if position_n = 7 then position_n <= 7;position_p <= 6;
				else position_p <= position_n;position_n <= position_n+1;
				end if;
			end if;

			--下降判断
			if clk_1'event and clk_1 = '1' and  btn_down = '1' then
				if position_n = 0 then position_n <= 0;position_p <= 1;
				else position_p <= position_n;position_n <= position_n-1;
				end if;
			end if;

			--向左判断
			if clk_1'event and clk_1 = '1' and  btn_left = '1' then
				if position_n_x = 0 then position_n_x <= 0;position_p_x <= 1;
				else position_p_x <= position_n_x;position_n_x <= position_n_x-1;
				end if;
			end if;

			--向右判断
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



