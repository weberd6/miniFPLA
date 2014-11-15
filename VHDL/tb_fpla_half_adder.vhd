library ieee;
use ieee.std_logic_1164.all;

entity tb_fpla_half_adder is
end entity tb_fpla_half_adder;

architecture fpla_half_adder of tb_fpla_half_adder is
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
    
    constant tb_R, tb_C : integer := 2;
    
    signal t_clk, t_config, t_normal_test : std_logic := '0';
    
    signal t_fpla_in, t_fpla_out : std_logic_vector((tb_R+tb_C-1) downto 0) := "0000";

    signal t_reset : std_logic :=  '1';
    
    constant T_off : time := 5 ns;
    constant T_on : time := 5 ns;
    constant T : time := T_on + T_off;
    
begin

    fpla0: fpla generic map(tb_R, tb_C)
              port map(
                clk => t_clk,
                reset => t_reset,
                config => t_config,
                normal_test => t_normal_test,
                top_in => t_fpla_in(0 downto 0),
                left_in => t_fpla_in(3 downto 3),
                bottom_in => t_fpla_in(2 downto 2),
                right_in => t_fpla_in(1 downto 1),
                top_out => t_fpla_out(0 downto 0),
                left_out => t_fpla_out(3 downto 3),
                bottom_out => t_fpla_out(2 downto 2),
                right_out => t_fpla_out(1 downto 1)
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
      
        -- Configure to be half adder
        wait for T;
        
        t_reset <= '0';
        t_config <= '1';

        t_fpla_in <= "0101";
        wait for T;

        t_fpla_in <= "0001";
        wait for T;

        t_fpla_in <= "0100";
        wait for T;

        t_fpla_in <= "0000";
        wait for T;

        t_fpla_in <= "0100";
        wait for T;

        t_fpla_in <= "0001";
        wait for 2*T;

        t_fpla_in <= "0000";
        wait for T;

        t_config <= '0';
        wait for T;


        -- Test half adder
        -- A = fpla_in(0) and fpla_in(1)
        -- B = fpla_in(2) and fpla_in(3)
        -- C = fpla_out(2) and fpla_out(3)
        -- S = fpla_out(0) and fpla_out(1)

        t_fpla_in <= "0011";
        wait for T;
        
        t_fpla_in <= "0000";
        wait for T;
        
        t_fpla_in <= "1100";
        wait for T;
        
        t_fpla_in <= "0011";
        wait for T;
        
        t_fpla_in <= "0000";
        wait for T;
        
        t_fpla_in <= "1111";
        wait for T;
        
        t_fpla_in <= "0011";
        wait for T;
        
        t_fpla_in <= "1111";
        wait for T;
        
        t_fpla_in <= "1100";
        wait for T;
        
        t_fpla_in <= "1111";
        wait for T;
        
        t_fpla_in <= "0000";
        wait for T;
        
        wait;
    end process test_process;

end fpla_half_adder;

