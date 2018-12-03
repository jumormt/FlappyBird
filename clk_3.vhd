--------------------------------------
--Design Unit   :	时钟3的计数输出
--File Name		:	clk_3.vhd
--Description	:	实现时钟3（1hz）的计数flag_1的输出
--Limitations	:   none
--System		:	VHDL 93
--Author		:	Xiao Cheng
--Revision		:   Version 1.0 2016-10-26
---------------------------------------
--输入输出接口设置解释参考文件flappybird.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clk_3 is
	port
	(
	pause: in std_logic;
	reset: in std_logic;
	clk_3:in std_logic;
	game_over_clk3:in integer range 0 to 2;
	game_over_clk32:in integer range 0 to 2;
	flag_1:out integer range 0 to 28
	);
end clk_3;

architecture clk_3_arc of clk_3 is
	signal flag_1_sig:integer range 0 to 28:=0;
	--flag_1的信号量
begin
	p:process(clk_3)
	begin
		--复位清零
		if reset = '1' then
			flag_1_sig <= 0;
			flag_1 <= 0;
		else
			if clk_3'event and clk_3 = '1' then
				if game_over_clk3 /= 0 and game_over_clk32 /= 0 then flag_1_sig <= 0;--游戏结束的复位
				elsif pause = '1' then
					flag_1_sig <= flag_1_sig;
				else
					flag_1_sig <= flag_1_sig +1;
				end if;
			end if;
			flag_1 <= flag_1_sig;
		end if;
	end process p;
end clk_3_arc;