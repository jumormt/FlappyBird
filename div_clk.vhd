--------------------------------------
--Design Unit   : 分频器1
--File Name   : div_clk.vhd
--Description : 24999分频，实现主时钟50MHZ的分频，用于二级分频
--Limitations :   none
--System    : VHDL 93
--Author    : Xiao Cheng
--Revision    :   Version 1.0 2016-10-26
---------------------------------------
--输入输出接口设置解释参考文件flappybird.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity div_clk is
port
  (
  clk:in std_logic;
  clk_out:out std_logic
  );
end div_clk;

architecture div_arc of div_clk is
    signal count:integer range 0 to 24999:=0;
    signal clk_1_sig:std_logic;
begin
  p:process(clk)
  begin
    if clk'event and clk = '1' then
      if count = 24999 then count <=0 ;clk_1_sig <= not clk_1_sig;
      else count <= count+1;
      end if;
    end if;
  clk_out <= clk_1_sig;

  end process p;
end div_arc;

