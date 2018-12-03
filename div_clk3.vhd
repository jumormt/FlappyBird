--------------------------------------
--Design Unit   :	��Ƶ��3
--File Name		:	div_clk3.vhd
--Description	:	ʵ��ʱ��3�ķ�Ƶ�����ڽ���clk_3��1hzʱ��
--Limitations	:   none
--System		:	VHDL 93
--Author		:	Xiao Cheng
--Revision		:   Version 1.0 2016-10-26
---------------------------------------
--��������ӿ����ý��Ͳο��ļ�flappybird.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity div_clk3 is
port
	(
	speed_mode:in integer range 0 to 3;
	clk:in std_logic;
	clk_3:out std_logic
	);
end div_clk3;

architecture div_arc of div_clk3 is
    signal count:integer range 0 to 499:=0;
		signal clk_3_sig:std_logic;
begin
	p:process(clk)
	begin
		if clk'event and clk = '1' then
			--��ͬ�ٶȶ�Ӧ��ͬ��Ƶ
			case speed_mode is
				when 0 =>
					if count = 899 then count <=0 ;clk_3_sig <= not clk_3_sig;
					else count <= count+1;
					end if;
			  when 1 =>
					if count = 499 then count <=0 ;clk_3_sig <= not clk_3_sig;
					else count <= count+1;
					end if;
				when 2 =>
					if count = 299 then count <=0 ;clk_3_sig <= not clk_3_sig;
					else count <= count+1;
					end if;
			  when 3 =>
					if count = 199 then count <=0 ;clk_3_sig <= not clk_3_sig;
					else count <= count+1;
					end if;
			end case;
		end if;
	clk_3 <= clk_3_sig;
	end process p;
end div_arc;
