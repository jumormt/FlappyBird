------------------------------------------
--Design Unit : 蜂鸣器输入
--File Name   : div_clk4.vhd
--Description : 作为蜂鸣器的接入频率信号，实现蜂鸣器的功能。
--Limitations : none
--System    : VHDL 93
--Author      : Xiao Cheng
--Revision    : Version 1.0 2016-10-26
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity div_clk4 is
port
  (
  clk:in std_logic;
  clk_f:out std_logic
  );
end div_clk4;

architecture div_arc of div_clk4 is
  signal count:integer range 0 to 1  :=  0;
  signal clk_f_sig:std_logic;
begin
  p:process(clk)
  begin
    if clk'event and clk = '1' then
      if count = 1 then count <=0 ;clk_f_sig <= not clk_f_sig;
      else count <= count+1;
      end if;
    end if;
    clk_f <= clk_f_sig;
  end process p;
end div_arc;


