--------------------------------------
--Design Unit   : 随机数产生器
--File Name   : random.vhd
--Description : 产生系统需要的随机数
--Limitations :   none
--System    : VHDL 93
--Author    : Xiao Cheng
--Revision    :   Version 1.0 2016-10-26
---------------------------------------
--输入输出接口设置解释参考文件flappybird.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity random is
port
  (
    clk:in std_logic;
    random_out:out integer range 0 to 16
  );
end random;

architecture random_arc of random is
  signal random_sig:integer range 0 to 16;
  signal count:integer range 0 to 22;
begin
  p:process(clk)
  begin
    if clk'event and clk = '1' then
      if count = 22 then count <= 0;
      else count <= count+1;
      end if;
      if count = 22 then
        if random_sig = 16 then random_sig <= 0;
        else random_sig <= random_sig +1;
        end if;
      end if;
    end if;

    random_out <= random_sig;
  end process p;
end random_arc;