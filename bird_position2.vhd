-------------------------------------------
--Design Unit   :	小鸟纵坐标输出
--File Name		:	bird_position2.vhd
--Description	:	实现玩家二小鸟纵坐标的输出
--Limitations	:	none
--System		:	VHDL 93
--Author		:	Xiao Cheng
--Revision		:	Version 1.0 2016-10-26
------------------------------------------
--输入输出接口设置解释参考文件flappybird.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bird_position2 is
	port
	(
	reset:in std_logic;
	clk_1:in std_logic;
	btn_up2:in std_logic;
	btn_down2:in std_logic;
	position_past2:out integer range 0 to 7:=5;
	position_now2:out integer range 0 to 7:=5
	);
end bird_position2;

architecture bird_position_arc of bird_position2 is
	signal position_p:integer range 0 to 7:=4;
	signal position_n:integer range 0 to 7:=4;

begin
	p:process(btn_up2,btn_down2)
	begin
		--复位
		if reset = '1' then
			position_n <= 4;
			position_past2 <= position_p;
			position_now2 <= position_n;
		else
			--向上
			if clk_1'event and clk_1 = '1' and btn_up2 = '1' then
				if position_n = 7 then position_n <= 7;position_p <= 6;
				else position_p <= position_n;position_n <= position_n+1;
				end if;
			end if;

			--向下
			if clk_1'event and clk_1 = '1' and  btn_down2 = '1' then
				if position_n = 0 then position_n <= 0;position_p <= 1;
				else position_p <= position_n;position_n <= position_n-1;
				end if;
			end if;

--				if position_n_x2 = 0 then position_n_x2 <= 0;position_p_x2 <= 1;
--				else position_p_x2 <= position_n_x2;position_n_x2 <= position_n_x2-1;
--				end if;
--			end if;
--
--			if clk_1'event and clk_1 = '1' and  btn_right2 = '1' then
--				if position_n_x2 = 7 then position_n_x2 <= 7;position_p_x2 <= 1;
--				else position_p_x2 <= position_n_x2;position_n_x2 <= position_n_x2+1;
--				end if;
--			end if;
			position_past2 <= position_p;
			position_now2 <= position_n;
		end if;
	end process p;
end bird_position_arc;