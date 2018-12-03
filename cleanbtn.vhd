------------------------------------------
--Design Unit :	防抖模块
--File Name	  :	cleanbtn.vhd
--Description :	实现按键的防抖动
--Limitations :	none
--System	  :	VHDL 93
--Author      :	Xiao Cheng
--Revision	  :	Version 1.0 2016-10-26
-------------------------------------------
--输入输出接口设置解释参考文件flappybird.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cleanbtn is
port(
	clk_1: in std_logic;
	--1000hz
	btn_up: in std_logic;
	btn_up_out: out std_logic;
	btn_down: in std_logic;
	btn_down_out: out std_logic;
	btn_left: in std_logic;
	btn_left_out: out std_logic;
	btn_right: in std_logic;
	btn_right_out: out std_logic;
	btn_up2: in std_logic;
	btn_up_out2: out std_logic;
	btn_down2: in std_logic;
	btn_down_out2: out std_logic;
	reset: in std_logic;
	reset_out: out std_logic
	);
end cleanbtn;

architecture cleanbtn_arc of cleanbtn is
	signal count1: integer range 0 to 40;
	signal btn_temp1: std_logic;--btn_up
	signal count2: integer range 0 to 40;
	signal btn_temp2: std_logic;--btn_down

	signal count12: integer range 0 to 40;
	signal btn_temp12: std_logic;--btn_up2
	signal count22: integer range 0 to 40;
	signal btn_temp22: std_logic;--btn_down2

	signal count1l: integer range 0 to 40;
	signal btn_temp1l: std_logic;--btn_left
	signal count2r: integer range 0 to 40;
	signal btn_temp2r: std_logic;--btn_right

	signal count3: integer range 0 to 40;
	signal btn_temp3: std_logic;--reset
begin

	p1:process(clk_1)
	begin
		if clk_1'event and clk_1 = '1' then
			if btn_up = '1' then
				if count1 = 40 then
					count1 <= count1;
					btn_temp1 <= '0';
				elsif count1 >= 30 then
					count1 <= count1 + 1;
					btn_temp1 <= '1';
				else
					count1 <= count1 + 1;
					btn_temp1 <= '0';
				end if;
			else
				count1 <= 0;
				btn_temp1 <= '0';
			end if;
		end if;
	end process p1;

	p2:process(clk_1)
	begin
		if clk_1'event and clk_1 = '1' then
			if btn_down = '1' then
				if count2 = 40 then
					count2 <= count2;
					btn_temp2 <= '0';
				elsif count2 >= 30 then
					count2 <= count2 + 1;
					btn_temp2 <= '1';
				else
					count2 <= count2 + 1;
					btn_temp2 <= '0';
				end if;
			else
				count2 <= 0;
				btn_temp2 <= '0';
			end if;
		end if;
	end process p2;

	p3:process(clk_1)
	begin
		if clk_1'event and clk_1 = '1' then
			if reset = '1' then
				if count3 = 40 then
					count3 <= count3;
					btn_temp3 <= '0';
				elsif count3 >= 30 then
					count3 <= count3 + 1;
					btn_temp3 <= '1';
				else
					count3 <= count3 + 1;
					btn_temp3 <= '0';
				end if;
			else
				count3 <= 0;
				btn_temp3 <= '0';
			end if;
		end if;
	end process p3;

	p4:process(clk_1)
	begin
		if clk_1'event and clk_1 = '1' then
			if btn_up2 = '1' then
				if count12 = 40 then
					count12 <= count12;
					btn_temp12 <= '0';
				elsif count12 >= 30 then
					count12 <= count12 + 1;
					btn_temp12 <= '1';
				else
					count12 <= count12 + 1;
					btn_temp12 <= '0';
				end if;
			else
				count12 <= 0;
				btn_temp12 <= '0';
			end if;
		end if;
	end process p4;

	p5:process(clk_1)
	begin
		if clk_1'event and clk_1 = '1' then
			if btn_down2 = '1' then
				if count22 = 40 then
					count22 <= count22;
					btn_temp22 <= '0';
				elsif count22 >= 30 then
					count22 <= count22 + 1;
					btn_temp22 <= '1';
				else
					count22 <= count22 + 1;
					btn_temp22 <= '0';
				end if;
			else
				count22 <= 0;
				btn_temp22 <= '0';
			end if;
		end if;
	end process p5;


	p6:process(clk_1)
	begin
	  if clk_1'event and clk_1 = '1' then
	    if btn_left = '1' then
	      if count1l = 40 then
	        count1l <= count1l;
	        btn_temp1l <= '0';
	      elsif count1l >= 30 then
	        count1l <= count1l + 1;
	        btn_temp1l <= '1';
	      else
	        count1l <= count1l + 1;
	        btn_temp1l <= '0';
	      end if;
	    else
	      count1l <= 0;
	      btn_temp1l <= '0';
	    end if;
	  end if;
	end process p6;

	p7:process(clk_1)
	begin
	  if clk_1'event and clk_1 = '1' then
	    if btn_right = '1' then
	      if count2r = 40 then
	        count2r <= count2r;
	        btn_temp2r <= '0';
	      elsif count2r >= 30 then
	        count2r <= count2r + 1;
	        btn_temp2r <= '1';
	      else
	        count2r <= count2r + 1;
	        btn_temp2r <= '0';
	      end if;
	    else
	      count2r <= 0;
	      btn_temp2r <= '0';
	    end if;
	  end if;
	end process p7;

	btn_up_out <= btn_temp1;
	btn_down_out <= btn_temp2;
	btn_up_out2 <= btn_temp12;
	btn_down_out2 <= btn_temp22;
	btn_left_out <= btn_temp1l;
	btn_right_out <= btn_temp2r;
	reset_out <= btn_temp3;
end cleanbtn_arc;