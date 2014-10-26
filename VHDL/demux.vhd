library ieee;
use ieee.std_logic_1164.all;

entity demux is
  port (
    a   : in  std_logic;
    s   : in  std_logic;
    b,c : out std_logic);
end entity demux;


architecture demux_behav of demux is
begin

    demux_process : process (a,s)
    begin

        if (s = '0') then
            b <= a;
        else
            c <= a;
        end if;

    end process demux_process;
end demux_behav;

