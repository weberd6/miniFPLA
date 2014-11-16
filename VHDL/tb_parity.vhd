
library ieee;
use ieee.std_logic_1164.all;

entity tb_fpla_parity is
end entity tb_fpla_parity;

architecture fpla_parity of tb_fpla_parity is
    component fpla
        generic(R : Integer := 2;
                C : Integer := 2);
        port(
            clk : in std_logic;
            reset : in std_logic;
            config : in std_logic;
            normal_test : in std_logic;
            top_in : in std_logic_vector(((C + (C mod 2))/2 - 1) downto 0);
            left_in : in std_logic_vector(((R + (R mod 2))/2 - 1) downto 0);
            bottom_in : in std_logic_vector(((C - (C mod 2))/2 - 1) downto 0);
            right_in : in std_logic_vector(((R - (R mod 2))/2 - 1) downto 0);
            top_out : out std_logic_vector(((C - (C mod 2))/2 - 1) downto 0);
            left_out : out std_logic_vector(((R - (R mod 2))/2 - 1) downto 0);
            bottom_out : out std_logic_vector(((C + (C mod 2))/2 - 1) downto 0);
            right_out : out std_logic_vector(((R + (R mod 2))/2 - 1) downto 0)
        );
    end component;
    
    constant tb_R : integer := 4;
    constant tb_C : integer := 5;
    
    signal t_clk, t_config, t_normal_test : std_logic := '0';
    
    signal t_fpla_in, t_fpla_out : std_logic_vector((tb_R+tb_C-1) downto 0) := "000000000";

    signal t_reset : std_logic :=  '1';
    
    constant T_off : time := 10 ns;
    constant T_on : time := 10 ns;
    constant T : time := T_on + T_off;
    
begin

    fpla0: fpla generic map(tb_R, tb_C)
              port map(
                clk => t_clk,
                reset => t_reset,
                config => t_config,
                normal_test => t_normal_test,
                top_in(0) => t_fpla_in(0), 
                top_in(1) => t_fpla_in(1),
                top_in(2) => t_fpla_in(2),
                left_in(0) => t_fpla_in(8),
                left_in(1) => t_fpla_in(7),
                bottom_in(0) => t_fpla_in(6),
                bottom_in(1) => t_fpla_in(5),
                right_in(0) => t_fpla_in(3),
                right_in(1) => t_fpla_in(4),
                top_out(0) => t_fpla_out(0),
                top_out(1) => t_fpla_out(1),
                left_out(0) => t_fpla_out(8),
                left_out(1) => t_fpla_out(7),
                bottom_out(0) => t_fpla_out(6),
                bottom_out(1) => t_fpla_out(5),
                bottom_out(2) => t_fpla_out(4),
                right_out(0) => t_fpla_out(2),
                right_out(1) => t_fpla_out(3)
              );

    clock_process: process
    begin
        clk_loop: loop
            if (t_clk = '0') then
               wait for T_off;
            elsif (t_clk = '1') then
                wait for T_on;
            end if;
            t_clk <= not t_clk;
        end loop clk_loop;
    end process clock_process;

    test_process: process
    begin
      
        -- Configure to be odd parity checker
        wait for T;
        
        t_reset <= '0';
        t_config <= '1';

        t_fpla_in <= "001100010";
        wait for T;
        
        t_fpla_in <= "000000110";
        wait for T;
        
        t_fpla_in <= "001100100";
        wait for T;
        
        t_fpla_in <= "000000000";
        wait for T;
        
        t_fpla_in <= "001000101";
        wait for T;
        
        t_fpla_in <= "001000001";
        wait for T;
        
        t_fpla_in <= "000000100";
        wait for T;
        
        t_fpla_in <= "000000000";
        wait for T;
        
        t_fpla_in <= "000000001";
        wait for T;
        
        t_fpla_in <= "001000101";
        wait for T;
        
        t_fpla_in <= "001000100";
        wait for T;
        
        t_fpla_in <= "000000000";
        wait for T;
        
        t_fpla_in <= "000000000";
        wait for T;
        
        t_fpla_in <= "001100111";
        wait for T;
        
        t_fpla_in <= "001100111";
        wait for T;
        
        t_fpla_in <= "000000000";
        wait for T;
        
        t_config <= '0';
        wait for 2*T;
        
        
        
        t_fpla_in <= "111111111";
        wait for 5*T;
        
        t_fpla_in <= "001101010";
        wait for 5*T;
        
        t_fpla_in <= "110000000";
        wait for 5*T;
        
        t_fpla_in <= "010101011";
        wait for 5*T;
        
        t_fpla_in <= "001100111";
        wait for 5*T;
        
        t_fpla_in <= "101101101";
        wait for 5*T;
        
        t_fpla_in <= "000101110";
        wait for 5*T;
        
        t_fpla_in <= "001001001";
        wait for 5*T;
        
        t_fpla_in <= "110110111";
        wait for 5*T;
        
        t_fpla_in <= "000000000";
        wait for 5*T;
        
        t_fpla_in <= "111111111";
        wait for 5*T;
        
        t_fpla_in <= "000000001";
        wait for 5*T;

        wait;
    end process test_process;

end fpla_parity;