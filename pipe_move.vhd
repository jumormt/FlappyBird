--------------------------------------
--Design Unit   :	�������
--File Name		:	pipe_move.vhd
--Description	:	�Թܵ���С�񡢹���������״̬���������и��£���ʵ����Ϸ�Ƿ�������ж�
--Limitations	:   none
--System		:	VHDL 93
--Author		:	Xiao Cheng
--Revision		:   Version 1.0 2016-10-26
---------------------------------------
--��������ӿ����ý��Ͳο��ļ�flappybird.vhd

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
	--�Զ���һ��17λ�����飬��Ź��ӵĿ�ȱλ�ó�ʼֵ
	signal random:matrix_index;
	signal G_sig:std_logic_vector (7 downto 0);
	signal R_sig:std_logic_vector (7 downto 0);
	signal C_sig:std_logic_vector (7 downto 0);
	signal count:integer range -1 to 7:=-1;
	--������������ʵ����ɨ��
	signal count_p:integer range -1 to 7:=-1;
	--���count������ǰһ״̬��ֵ
	signal flag_past:integer range 0 to 28;
	--���flag_1ǰһ״̬��ֵ
	signal game_over_sig:integer range 0 to 2;
	signal game_over_sig2:integer range 0 to 2;
	signal score_sig:integer range 0 to 13:=0;
	signal score_sig2:integer range 0 to 13:=0;
	signal count_s1:integer range 0 to 20:=0;
	--΢�ͼ�����������ʵ�ַ����ж�
	signal position_px_sig:integer range 0 to 7;
	signal position_nx_sig:integer range 0 to 7;
	signal count_r:integer range 0 to 17;
--	signal random_count:integer range 0 to 113;
begin
	p1:process(clk_2,reset)
	begin
		--��λ�س�ʼ״̬
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
--				|-----------------------------------���������-------------------------------------------|
--				==========================================================================================
					if count_r = 17 then count_r <= 17;
					else count_r <= count_r+1;
					end if;
--					random_count <= random_count +17;
					if count_r /= 17 then
						random (count_r) <= random1(random_out);
					end if;
--				==========================================================================================
--				|-----------------------------------��������״̬�ĸ���-----------------------------------|
--				==========================================================================================
					--���ӵ�ÿһ���ƶ���Լ�����count�������¼���
					if flag_1 /= flag_past then count <= -1;flag_past <= flag_1;
					end if;
					--������״̬����
					if count = 7 then count <= 0;
					else count <= count+1;
					end if;
					--��������״̬�ĸ���
					for i in 0 to 7 loop
						if i = count then C_sig(i) <= '0';
						else C_sig(i) <= '1';
						end if;
					end loop;
					C <= C_sig;
					---------------------------------------------------------------------------------------------


--				====================================================================================
--   			|--------------------------���¹ܵ���λ�ã�������⣩------------------------------|
--				====================================================================================
					--ÿ��ˢ��һ��ʱ�ȶԹܵ�������ճ�ʼ��
					if count /= count_p then
						for i in 0 to 7 loop
							G_sig(i) <= '0';
						end loop;
						count_p <= count;
					end if;
					-----------------------��ӡ����ˢ�µ���һ������Ӧ�Ĺܵ�---------------------
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
--				 |-----------------------------������ĸ��¼���Ϸ״̬�ж�---------------------------------|
--				 ============================================================================================
					if member = '0' then--��ֻ��һ�����ʱ
						if more = '1' then--������ǰ���ƶ�ʱ��������ĺ�����
							position_px_sig <= position_past_x;
							position_nx_sig <= position_now_x;
						else
							position_px_sig <= 4;
							position_nx_sig <= 4;
						end if;
						if game_over_sig = 2 then--��Ϸʧ��
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
						elsif game_over_sig = 1 then--��Ϸͨ��

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
						else--��Ϸ��������ʱ
							------------------------------------------------------------------------------------
							-----------------------------------С��λ�õĸ���-----------------------------------
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
							-----------------------------�����ѣ���Ϸ�����Լ���Ϸ״̬�ĸ���--------------------------
							-----------------------------------------------------------------------------------------
							--΢�ͼ�����count_s1�ĸ��£���1������20����20��ͣ��
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
													--�ж�΢�ͼ������Ƿ��¼����һ�����ڵ���������ɨ�裨�ӵ�һ��ɨ���ڰ��У�
													if count_s1 >= 8 then score_sig <= score_sig+1;game_over_sig <= 2;
													else score_sig <= score_sig;game_over_sig <= 2;
													end if;
												end if;
											end if;
										else
											if count = position_now+1 then
												if G_sig(position_nx_sig) = '1' then
													--�ж�΢�ͼ������Ƿ��¼����һ�����ڵ���������ɨ�裨�ӵ�һ��ɨ���ڰ��У�
													if count_s1 >= 8 then score_sig <= score_sig+1;game_over_sig <= 2;
													else score_sig <= score_sig;game_over_sig <= 2;
													end if;
												end if;
											end if;
										end if;
										if game_over_sig = 0 then
											--�ж�΢�ͼ������Ƿ��¼����һ�����ڵ���������ɨ�裨�ӵ�һ��ɨ���ڰ��У�����ɨ��һ��ʱ���з����ж�
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
					if member = '1' then--�����������ͬʱ������Ϸʱ
						if game_over_sig /= 0 then--���һ��Ϸ����ʱ
							if game_over_sig2 /=0 then--���һ����Ҷ�ͬʱ��Ϸ����
								--�Ƚ�������ҵķ���������ʤ���ж�
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
							elsif game_over_sig2 = 0 then--ֻ����Ҷ���Ϸ����
								--����С��
								if count = position_past2 then R_sig(4) <= '0';
								end if;
								if count = position_now2 then R_sig(4) <= '1';
								else
									for i in 0 to 7 loop
										R_sig(i) <= '0';
									end loop;
								end if;
								R <= R_sig;
								--�����ж�
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
						elsif game_over_sig = 0 then--���һ��Ϸ����
							if game_over_sig2 /= 0 then--��Ҷ���Ϸ������ֻ�����һ������Ϸ
								--����С��
								if count = position_past then R_sig(4) <= '0';
								end if;
								if count = position_now then R_sig(4) <= '1';
								else
									for i in 0 to 7 loop
										R_sig(i) <= '0';
									end loop;
								end if;
									R <= R_sig;
								--���һ�����ж�
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
							elsif game_over_sig2 = 0 then--���һ����Ҷ�ͬʱ������Ϸ
								--����С��
								if count = position_past then R_sig(4) <= '0';
								end if;
								if count = position_past2 then R_sig(4) <= '0';
								end if;
								if count = position_now or count = position_now2 then R_sig(4) <= '1';
								else
									R_sig <= "00000000";
								end if;
								R <= R_sig;
								--�������һ����
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
								--������Ҷ�����
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
