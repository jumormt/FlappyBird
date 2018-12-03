--------------------------------------
--Design Unit   :	模式选择模块
--File Name		:	mode_select.vhd
--Description	:	实现对速度，单双人以及是否能前后移动模式的选择，并输出对应的信号
--Limitations	:   none
--System		:	VHDL 93
--Author		:	Xiao Cheng
--Revision		:   Version 1.0 2016-10-26
---------------------------------------
--输入输出接口设置解释参考文件flappybird.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mode_select is
port
	(
	sw7:in std_logic;
	sw6:in std_logic;
	sw1:in std_logic;
	sw0:in std_logic;
	speed_mode:out integer range 0 to 3;
	speed_mode_view:out integer range 0 to 3;
	member:out std_logic;
	--人数
	member_view:out integer range 0 to 2;
	more:out std_logic
	--是否能前后
	);
end mode_select;

architecture mode_select_arc of mode_select is
begin
	p:process(sw1,sw0)
	variable speed_sig:std_logic_vector (0 to 1);
	variable sw_sig:std_logic_vector (0 to 1);
	begin
		speed_sig := sw1&sw0;
		sw_sig := sw7&sw6;

		--速度的判断
		case speed_sig is
			when "00" => speed_mode <= 0;speed_mode_view <= 0;
			when "01" => speed_mode <= 1;speed_mode_view <= 1;
			when "10" => speed_mode <= 2;speed_mode_view <= 2;
			when "11" => speed_mode <= 3;speed_mode_view <= 3;
		end case;

		--人数以及是否前后的判断
		case sw_sig is
			when "00" => member <= '0'; more <= '0'; member_view <= 1;
			when "01" => member <= '0'; more <= '1'; member_view <= 1;
			when "10" => member <= '1'; more <= '0'; member_view <= 2;
			when "11" => member <= '1'; more <= '1'; member_view <= 2;
		end case;
	end process p;
end mode_select_arc;
