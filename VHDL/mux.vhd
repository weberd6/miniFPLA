library ieee;
use ieee.std_logic_1164.all;

entity mux is
  port (
    a,b : in  std_logic;
    s   : in  std_logic;
    c   : out std_logic);
  end entity mux;
  

architecture mux_behav of mux is
  begin 
    mux_process : process (a,b,s)
    begin
      
      if s = '0' then
        c <= not a after 1 ns;
      else
        c <= not b after 1 ns;
      end if;
        
      end process mux_process;

  end mux_behav;

