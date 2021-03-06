library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Df_f is 
    port(
        CLK :in std_logic;      
        CE :in std_logic;   
        RESET :in std_logic;  
        D :in  std_logic;
        Q : out std_logic       
    );
end Df_f;

architecture BEHAVIORAL of Df_f is  --architecture of the circuit.
begin  --"begin" statement for architecture.

    process(CLK) --process with sensitivity list.
    begin  --"begin" statment for the process.
        if ( rising_edge(CLK) ) then  
            if (RESET = '1') then
                Q <= '0';-- after 1.5 ns;
            elsif(RESET = '0') then
                if ( CE = '1') then
         	          Q <= D;-- after 1.5 ns;       
                end if;
            end if;
        end if;       
    end process;  --end of process statement.

end Behavioral;
