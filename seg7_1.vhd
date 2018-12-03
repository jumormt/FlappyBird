--------------------------------------
--Design Unit   :	数码管显示模块
--File Name		:	seg7_1.vhd
--Description	:	实现分数、项说明、项内容的数码管显示
--Limitations	:   none
--System		:	VHDL 93
--Author		:	Xiao Cheng
--Revision		:   Version 1.0 2016-10-26
---------------------------------------
--输入输出接口设置解释参考文件flappybird.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity seg7_1 is
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
end seg7_1;

architecture seg7_1_arc of seg7_1 is
	signal count:integer range 0 to 7:=0;
	--计数器
	signal cat_sig:std_logic_vector (7 downto 0);
	--公共阴极的信号量
begin
	p:process (clk_2,score)
    begin
    --计数状态的更新，每次只有一个阴极有效
		if clk_2'event and clk_2 = '1' then
			if count = 7 then count <= 0;
			else count <= count +1;
			end if;
			for i in 0 to 7 loop
				if i = 7-count then cat_sig(i) <= '0';
				else cat_sig(i) <= '1';
				end if;
			end loop;
			for i in 0 to 7 loop
				cat(i) <= cat_sig(i);
			end loop;

			--判断计数状态，从而使得对应1~8数码管显示对应内容
			case count is
				--第7个管子显示玩家一分数的十位
				when 7 =>
					case score is
						when 0 => score_view <= "1111110";
						when 1 => score_view <= "1111110";
						when 2 => score_view <= "1111110";
						when 3 => score_view <= "1111110";
						when 4 => score_view <= "1111110";
						when 5 => score_view <= "1111110";
						when 6 => score_view <= "1111110";
						when 7 => score_view <= "1111110";
						when 8 => score_view <= "1111110";
						when 9 => score_view <= "1111110";
						when 10 => score_view <= "0110000";
						when 11 => score_view <= "0110000";
						when 12 => score_view <= "0110000";
					end case;
				--第八个管子显示玩家一分数的各位
				when 0 =>
					case score is
						when 0 => score_view <= "1111110";
						when 1 => score_view <= "0110000";
						when 2 => score_view <= "1101101";
						when 3 => score_view <= "1111001";
						when 4 => score_view <= "0110011";
						when 5 => score_view <= "1011011";
						when 6 => score_view <= "1011111";
						when 7 => score_view <= "1110000";
						when 8 => score_view <= "1111111";
						when 9 => score_view <= "1111011";
						when 10 => score_view <= "1111110";
						when 11 => score_view <= "0110000";
						when 12 => score_view <= "1101101";
					end case;
				--第二个管子显示游戏速度
				when 2 =>
					case speed_mode_view is
						when 0 => score_view <= "1111110";
						when 1 => score_view <= "0110000";
						when 2 => score_view <= "1101101";
						when 3 => score_view <= "1111001";
					end case;
				--第五个管子显示玩家二分数的十位
				when 5 =>
					case score2 is
						when 0 => score_view <= "1111110";
						when 1 => score_view <= "1111110";
						when 2 => score_view <= "1111110";
						when 3 => score_view <= "1111110";
						when 4 => score_view <= "1111110";
						when 5 => score_view <= "1111110";
						when 6 => score_view <= "1111110";
						when 7 => score_view <= "1111110";
						when 8 => score_view <= "1111110";
						when 9 => score_view <= "1111110";
						when 10 => score_view <= "0110000";
						when 11 => score_view <= "0110000";
						when 12 => score_view <= "0110000";
					end case;
				--第六个管子显示玩家二分数的个位
				when 6 =>
					case score2 is
						when 0 => score_view <= "1111110";
						when 1 => score_view <= "0110000";
						when 2 => score_view <= "1101101";
						when 3 => score_view <= "1111001";
						when 4 => score_view <= "0110011";
						when 5 => score_view <= "1011011";
						when 6 => score_view <= "1011111";
						when 7 => score_view <= "1110000";
						when 8 => score_view <= "1111111";
						when 9 => score_view <= "1111011";
						when 10 => score_view <= "1111110";
						when 11 => score_view <= "0110000";
						when 12 => score_view <= "1101101";
					end case;
				--第一个管子，显示形状“S”，表示是速度标志
				when 1 =>
					score_view <= "1011011";
				--第三个管子显示形状“n”，表示是人数标志
				when 3 =>
					score_view <= "1110110";
				--第四个管子显示游戏人数
				when 4 =>
					if member_view = 1 then score_view <= "0110000";
					elsif member_view = 2 then score_view <= "1101101";
					else score_view <= "1111110";
					end if;
			end case;
	   end if;
   end process p;
end seg7_1_arc;