--------------------------------------
--Design Unit   :	点阵输出
--File Name		:	pipe_move.vhd
--Description	:	对管道、小鸟、公共阴极的状态，分数进行更新，并实现游戏是否结束的判断
--Limitations	:   none
--System		:	VHDL 93
--Author		:	Xiao Cheng
--Revision		:   Version 1.0 2016-10-26
---------------------------------------
--输入输出接口设置解释参考文件flappybird.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pipe_move is
port
	(
	random_out:in integer range 0 to 16;
	member:in std_logic;
	more:in std_logic;
	reset:in std_logic;
	flag_1:in integer range 0 to 28;
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
	score2:out integer range 0 to 12;
	game_over_clk32:out integer range 0 to 2;
	game_over_clk3:out integer range 0 to 2
	);
end pipe_move;

architecture pipe_move_arc of pipe_move is
	type matrix_index is array (16 downto 0) of integer range 0 to 5;
	signal random1:matrix_index:=(1,2,4,3,2,0,2,3,0,2,4,5,1,3,4,2,1);
	--自定义一个17位的数组，填放管子的空缺位置初始值
	signal random:matrix_index;
	signal G_sig:std_logic_vector (7 downto 0);
	signal R_sig:std_logic_vector (7 downto 0);
	signal C_sig:std_logic_vector (7 downto 0);
	signal count:integer range -1 to 7:=-1;
	--计数器，用来实现行扫描
	signal count_p:integer range -1 to 7:=-1;
	--存放count计数器前一状态的值
	signal flag_past:integer range 0 to 28;
	--存放flag_1前一状态的值
	signal game_over_sig:integer range 0 to 2;
	signal game_over_sig2:integer range 0 to 2;
	signal score_sig:integer range 0 to 13:=0;
	signal score_sig2:integer range 0 to 13:=0;
	signal count_s1:integer range 0 to 20:=0;
	--微型计数器，辅助实现分数判断
	signal position_px_sig:integer range 0 to 7;
	signal position_nx_sig:integer range 0 to 7;
	signal count_r:integer range 0 to 17;
--	signal random_count:integer range 0 to 113;
begin
	p1:process(clk_2,reset)
	begin
		--复位回初始状态
		if reset = '1' then
			C <= "11111111";
			count <= -1;
			game_over_sig <= 0;
			game_over_sig2 <= 0;
			count_s1 <= 0;
			score_sig <= 0;
			score_sig2 <= 0;
			count_p <= -1;
			flag_past <= 0;
			game_over_clk3 <= game_over_sig;
			game_over_clk32 <= game_over_sig2;
			score2 <= score_sig2;
			score <= score_sig;
			count_r <= 0;
			else
				if clk_2'event and clk_2 = '1' then
--				==========================================================================================
--				|-----------------------------------更新随机数-------------------------------------------|
--				==========================================================================================
					if count_r = 17 then count_r <= 17;
					else count_r <= count_r+1;
					end if;
--					random_count <= random_count +17;
					if count_r /= 17 then
						random (count_r) <= random1(random_out);
					end if;
--				==========================================================================================
--				|-----------------------------------点阵阴极状态的更新-----------------------------------|
--				==========================================================================================
					--管子的每一次移动便对计数器count进行重新计数
					if flag_1 /= flag_past then count <= -1;flag_past <= flag_1;
					end if;
					--计数器状态更新
					if count = 7 then count <= 0;
					else count <= count+1;
					end if;
					--点阵阴极状态的更新
					for i in 0 to 7 loop
						if i = count then C_sig(i) <= '0';
						else C_sig(i) <= '1';
						end if;
					end loop;
					C <= C_sig;
					---------------------------------------------------------------------------------------------


--				====================================================================================
--   			|--------------------------更新管道的位置（较难理解）------------------------------|
--				====================================================================================
					--每次刷新一行时先对管道进行清空初始化
					if count /= count_p then
						for i in 0 to 7 loop
							G_sig(i) <= '0';
						end loop;
						count_p <= count;
					end if;
					-----------------------打印正在刷新的这一行所对应的管道---------------------
					for i in 0 to 16 loop
						if 7-flag_1+2*i >= 0 and 7-flag_1+2*i <= 7 then
							if count /= random(i) and count /= random(i)+1 and count /= random(i)+2 then
									G_sig(7-flag_1+2*i) <= '1';
							else
									G_sig(7-flag_1+2*i) <= '0';
							end if;
						end if;
					end loop;
						G <= G_sig;
					-----------------------------------------------------------------------------

--				 ============================================================================================
--				 |-----------------------------点阵红点的更新及游戏状态判断---------------------------------|
--				 ============================================================================================
					if member = '0' then--当只有一个玩家时
						if more = '1' then--当可以前后移动时，引入鸟的横坐标
							position_px_sig <= position_past_x;
							position_nx_sig <= position_now_x;
						else
							position_px_sig <= 4;
							position_nx_sig <= 4;
						end if;
						if game_over_sig = 2 then--游戏失败
							case count is
								when 7 => R_sig <= "10000001";G_sig <= "00000000";
								when 6 => R_sig <= "01000010";G_sig <= "00000000";
								when 5 => R_sig <= "00100100";G_sig <= "00000000";
								when 4 => R_sig <= "00011000";G_sig <= "00000000";
								when 3 => R_sig <= "00011000";G_sig <= "00000000";
								when 2 => R_sig <= "00100100";G_sig <= "00000000";
								when 1 => R_sig <= "01000010";G_sig <= "00000000";
								when 0 => R_sig <= "10000001";G_sig <= "00000000";
								when others => R_sig <= "00000000";G_sig <= "00000000";
							end case;
							R <= R_sig;
							G <= G_sig;
						elsif game_over_sig = 1 then--游戏通关

							case count is
								when 7 => R_sig <= "00000000";G_sig <= "10000001";
								when 6 => R_sig <= "00000000";G_sig <= "10000001";
								when 5 => R_sig <= "00000000";G_sig <= "10000001";
								when 4 => R_sig <= "00000000";G_sig <= "10000001";
								when 3 => R_sig <= "00000000";G_sig <= "10000001";
								when 2 => R_sig <= "00000000";G_sig <= "01000010";
								when 1 => R_sig <= "00000000";G_sig <= "00100100";
								when 0 => R_sig <= "00000000";G_sig <= "00011000";
								when others => R_sig <= "00000000";G_sig <= "00000000";
							end case;
							R <= R_sig;
							G <= G_sig;
						else--游戏继续进行时
							------------------------------------------------------------------------------------
							-----------------------------------小鸟位置的更新-----------------------------------
							------------------------------------------------------------------------------------
							if count = position_past then R_sig(position_px_sig) <= '0';
							end if;
							if count = position_now then R_sig(position_nx_sig) <= '1';
							else
								R_sig <= "00000000";
							end if;
								R <= R_sig;
							-------------------------------------------------------------------------------------

							-----------------------------------------------------------------------------------------
							-----------------------------（较难）游戏分数以及游戏状态的更新--------------------------
							-----------------------------------------------------------------------------------------
							--微型计数器count_s1的更新，从1计数到20，到20作停留
							if count_s1 = 20 then count_s1 <= 20;
							else count_s1 <= count_s1 + 1;
							end if;
							if score_sig = 12 then game_over_sig <= 1;
							else
								if game_over_sig = 2 then score_sig <= score_sig;
								else
									if flag_1 >= 3-(position_nx_sig-4) and flag_1 rem 2 = (1-(position_nx_sig rem 2)) then
										if flag_1 /= flag_past then count_s1 <= 0;flag_past <= flag_1;
										end if;
										if position_now = 7 then
											if count = position_now then
												if G_sig(position_nx_sig) = '1' then
													--判断微型计数器是否记录完了一个周期的完整的行扫描（从第一行扫到第八行）
													if count_s1 >= 8 then score_sig <= score_sig+1;game_over_sig <= 2;
													else score_sig <= score_sig;game_over_sig <= 2;
													end if;
												end if;
											end if;
										else
											if count = position_now+1 then
												if G_sig(position_nx_sig) = '1' then
													--判断微型计数器是否记录完了一个周期的完整的行扫描（从第一行扫到第八行）
													if count_s1 >= 8 then score_sig <= score_sig+1;game_over_sig <= 2;
													else score_sig <= score_sig;game_over_sig <= 2;
													end if;
												end if;
											end if;
										end if;
										if game_over_sig = 0 then
											--判断微型计数器是否记录完了一个周期的完整的行扫描（从第一行扫到第八行），在扫下一行时进行分数判断
											if count_s1 = 9 then
												score_sig <= score_sig+1;game_over_sig <= 0;
											end if;
										end if;
									end if;
								end if;
							end if;
							game_over_clk3 <= game_over_sig;
							score <= score_sig;
						end if;
					end if;
--=======================================================================================================
					if member = '1' then--当有两个玩家同时进行游戏时
						if game_over_sig /= 0 then--玩家一游戏结束时
							if game_over_sig2 /=0 then--玩家一和玩家二同时游戏结束
								--比较两个玩家的分数，进行胜负判断
								if score_sig > score_sig2 then
									case count is
										when 7 => R_sig <= "00000000";G_sig <= "01001110";
										when 6 => R_sig <= "00000000";G_sig <= "01101010";
										when 5 => R_sig <= "00000000";G_sig <= "01001110";
										when 4 => R_sig <= "00000000";G_sig <= "01000010";
										when 3 => R_sig <= "00000000";G_sig <= "11100010";
										when 2 => R_sig <= "00000000";G_sig <= "01000010";
										when 1 => R_sig <= "00000000";G_sig <= "00100100";
										when 0 => R_sig <= "00000000";G_sig <= "00011000";
										when others => R_sig <= "00000000";G_sig <= "00000000";
									end case;
									R <= R_sig;
									G <= G_sig;
								elsif score_sig < score_sig2 then
									case count is
										when 7 => R_sig <= "00000000";G_sig <= "01111110";
										when 6 => R_sig <= "00000000";G_sig <= "01001010";
										when 5 => R_sig <= "00000000";G_sig <= "01111110";
										when 4 => R_sig <= "00000000";G_sig <= "00010010";
										when 3 => R_sig <= "00000000";G_sig <= "01110010";
										when 2 => R_sig <= "00000000";G_sig <= "01000010";
										when 1 => R_sig <= "00000000";G_sig <= "00100100";
										when 0 => R_sig <= "00000000";G_sig <= "00011000";
										when others => R_sig <= "00000000";G_sig <= "00000000";
									end case;
									R <= R_sig;
									G <= G_sig;
								else
									case count is
										when 7 => R_sig <= "00000000";G_sig <= "11111111";
										when 6 => R_sig <= "00000000";G_sig <= "11111111";
										when 5 => R_sig <= "00000000";G_sig <= "00011000";
										when 4 => R_sig <= "00000000";G_sig <= "00011000";
										when 3 => R_sig <= "00000000";G_sig <= "00011000";
										when 2 => R_sig <= "00000000";G_sig <= "00011000";
										when 1 => R_sig <= "00000000";G_sig <= "00011000";
										when 0 => R_sig <= "00000000";G_sig <= "00011000";
										when others => R_sig <= "00000000";G_sig <= "00000000";
									end case;
									R <= R_sig;
									G <= G_sig;
								end if;
							elsif game_over_sig2 = 0 then--只有玩家二游戏进行
								--更新小鸟
								if count = position_past2 then R_sig(4) <= '0';
								end if;
								if count = position_now2 then R_sig(4) <= '1';
								else
									for i in 0 to 7 loop
										R_sig(i) <= '0';
									end loop;
								end if;
								R <= R_sig;
								--分数判断
								if count_s1 = 20 then count_s1 <= 20;
								else count_s1 <= count_s1 + 1;
								end if;
								if score_sig2 = 12 then game_over_sig2 <= 1;
								else
									if game_over_sig2 = 2 then score_sig2 <= score_sig2;
									else
										if flag_1 >= 3 and flag_1 rem 2 = 1 then
											if flag_1 /= flag_past then count_s1 <= 0;flag_past <= flag_1;
											end if;
											if count = position_now2+1 or (count = 7 and position_now2 = 7)then
												if G_sig(4) = '1' then
													if count_s1 >= 8 then score_sig2 <= score_sig2+1;game_over_sig2 <= 2;
													else score_sig2 <= score_sig2;game_over_sig2 <= 2;
													end if;
												end if;
											end if;
											if game_over_sig2 = 0 then
												if count_s1 = 9 then
													score_sig2 <= score_sig2+1;game_over_sig2 <= 0;
												end if;
											end if;
										end if;
									end if;
								end if;
								game_over_clk32 <= game_over_sig2;
								score2 <= score_sig2;
								game_over_clk3 <= game_over_sig;
								score <= score_sig;
							end if;
						elsif game_over_sig = 0 then--玩家一游戏进行
							if game_over_sig2 /= 0 then--玩家二游戏结束，只有玩家一进行游戏
								--更新小鸟
								if count = position_past then R_sig(4) <= '0';
								end if;
								if count = position_now then R_sig(4) <= '1';
								else
									for i in 0 to 7 loop
										R_sig(i) <= '0';
									end loop;
								end if;
									R <= R_sig;
								--玩家一分数判断
								if count_s1 = 20 then count_s1 <= 20;
								else count_s1 <= count_s1 + 1;
								end if;
								if score_sig = 12 then game_over_sig <= 1;
								else
									if game_over_sig = 2 then score_sig <= score_sig;
									else
										if flag_1 >= 3 and flag_1 rem 2 = 1 then
											if flag_1 /= flag_past then count_s1 <= 0;flag_past <= flag_1;
											end if;
											if count = position_now+1 or (count = 7 and position_now = 7)then
												if G_sig(4) = '1' then
													if count_s1 >= 8 then score_sig <= score_sig+1;game_over_sig <= 2;
													else score_sig <= score_sig;game_over_sig <= 2;
													end if;
												end if;
											end if;
											if game_over_sig = 0 then
												if count_s1 = 9 then
													score_sig <= score_sig+1;game_over_sig <= 0;
												end if;
											end if;
										end if;
									end if;
								end if;
								game_over_clk3 <= game_over_sig;
								score <= score_sig;
								game_over_clk32 <= game_over_sig2;
								score2 <= score_sig2;
							elsif game_over_sig2 = 0 then--玩家一和玩家二同时进行游戏
								--更新小鸟
								if count = position_past then R_sig(4) <= '0';
								end if;
								if count = position_past2 then R_sig(4) <= '0';
								end if;
								if count = position_now or count = position_now2 then R_sig(4) <= '1';
								else
									R_sig <= "00000000";
								end if;
								R <= R_sig;
								--更新玩家一分数
								if count_s1 = 20 then count_s1 <= 20;
								else count_s1 <= count_s1 + 1;
								end if;
								if score_sig = 12 then game_over_sig <= 1;
								else
									if game_over_sig = 2 then score_sig <= score_sig;
									else
										if flag_1 >= 3 and flag_1 rem 2 = 1 then
											if flag_1 /= flag_past then count_s1 <= 0;flag_past <= flag_1;
											end if;
											if count = position_now+1 or (count = 7 and position_now = 7)then
												if G_sig(4) = '1' then
													if count_s1 >= 8 then score_sig <= score_sig+1;game_over_sig <= 2;
													else score_sig <= score_sig;game_over_sig <= 2;
													end if;
												end if;
											end if;
											if game_over_sig = 0 then
												if count_s1 = 9 then
													score_sig <= score_sig+1;game_over_sig <= 0;
												end if;
											end if;
										end if;
									end if;
								end if;
								game_over_clk3 <= game_over_sig;
								score <= score_sig;
								--更新玩家二分数
								if score_sig2 = 12 then game_over_sig2 <= 1;
								else
									if game_over_sig2 = 2 then score_sig2 <= score_sig2;
									else
										if flag_1 >= 3 and flag_1 rem 2 = 1 then
											if flag_1 >= 3 and flag_1 rem 2 = 1 then
											end if;
											if count = position_now2+1 or (count = 7 and position_now2 = 7) then
												if G_sig(4) = '1' then
													if count_s1 >= 8 then score_sig2 <= score_sig2+1;game_over_sig2 <= 2;
													else score_sig2 <= score_sig2;game_over_sig2 <= 2;
													end if;
												end if;
											end if;
											if game_over_sig2 = 0 then
												if count_s1 = 9 then
													score_sig2 <= score_sig2+1;game_over_sig2 <= 0;
												end if;
											end if;
										end if;
									end if;
								end if;
								game_over_clk32 <= game_over_sig2;
								score2 <= score_sig2;
							end if;
						end if;
					end if;
				end if;
		end if;
	end process p1;
	--p2:process(score_sig,score_sig2,clk_2)
	--begin
	--	if score_sig'event or score_sig2'event then
  --	beep <= clk_f;
	--else beep <= '0';
	--end if;
	--end process p2;
end pipe_move_arc;
