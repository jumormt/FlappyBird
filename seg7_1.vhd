--------------------------------------
--Design Unit   :	�������ʾģ��
--File Name		:	seg7_1.vhd
--Description	:	ʵ�ַ�������˵���������ݵ��������ʾ
--Limitations	:   none
--System		:	VHDL 93
--Author		:	Xiao Cheng
--Revision		:   Version 1.0 2016-10-26
---------------------------------------
--��������ӿ����ý��Ͳο��ļ�flappybird.vhd

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
	--������
	signal cat_sig:std_logic_vector (7 downto 0);
	--�����������ź���
begin
	p:process (clk_2,score)
    begin
    --����״̬�ĸ��£�ÿ��ֻ��һ��������Ч
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

			--�жϼ���״̬���Ӷ�ʹ�ö�Ӧ1~8�������ʾ��Ӧ����
			case count is
				--��7��������ʾ���һ������ʮλ
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
				--�ڰ˸�������ʾ���һ�����ĸ�λ
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
				--�ڶ���������ʾ��Ϸ�ٶ�
				when 2 =>
					case speed_mode_view is
						when 0 => score_view <= "1111110";
						when 1 => score_view <= "0110000";
						when 2 => score_view <= "1101101";
						when 3 => score_view <= "1111001";
					end case;
				--�����������ʾ��Ҷ�������ʮλ
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
				--������������ʾ��Ҷ������ĸ�λ
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
				--��һ�����ӣ���ʾ��״��S������ʾ���ٶȱ�־
				when 1 =>
					score_view <= "1011011";
				--������������ʾ��״��n������ʾ��������־
				when 3 =>
					score_view <= "1110110";
				--���ĸ�������ʾ��Ϸ����
				when 4 =>
					if member_view = 1 then score_view <= "0110000";
					elsif member_view = 2 then score_view <= "1101101";
					else score_view <= "1111110";
					end if;
			end case;
	   end if;
   end process p;
end seg7_1_arc;