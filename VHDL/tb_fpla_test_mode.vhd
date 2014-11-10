library ieee;
use ieee.std_logic_1164.all;

entity tb_fpla_test_mode is
end entity tb_fpla_test_mode;

architecture fpla_test_mode of tb_fpla_test_mode is
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
    
begin

    fpla0: fpla generic map(tb_R, tb_C)
              port map(
                clk => t_clk,
                reset => t_reset,
                config => t_config,
                normal_test => t_normal_test,
                top_in => t_fpla_in(2 downto 0),
                left_in => t_fpla_in(8 downto 7),
                bottom_in => t_fpla_in(6 downto 5),
                right_in => t_fpla_in(4 downto 3),
                top_out => t_fpla_out(1 downto 0),
                left_out => t_fpla_out(8 downto 7),
                bottom_out => t_fpla_out(6 downto 4),
                right_out => t_fpla_out(3 downto 2)
              );

    clock_process: process
    begin
        clk_loop: loop
            wait for 5 ns;
            t_clk <= not t_clk;
        end loop clk_loop;
    end process clock_process;

    test_process: process
    begin
        wait for 7.5 ns;
        
        t_reset <= '0';
        t_normal_test <= '1';
        wait for 5 ns;
        
        t_fpla_in <= "111110101";
        wait for 10 ns;
        
        t_fpla_in <= "101011100";
        wait for 10 ns;
        
        t_fpla_in <= "110011000";
        wait for 10 ns;
        
        t_fpla_in <= "000011111";
        wait for 10 ns;
        
        t_fpla_in <= "011011010";
        wait for 10 ns;
        
        t_fpla_in <= "100111111";
        wait for 10 ns;
        
        t_fpla_in <= "010011010";
        wait for 10 ns;
        
        t_fpla_in <= "011100011";
        wait for 10 ns;
        
        t_fpla_in <= "011010110";
        wait for 10 ns;
        
        t_fpla_in <= "101111001";
        wait for 10 ns;
        
        t_fpla_in <= "011111000";
        wait for 10 ns;
        
        t_fpla_in <= "101010101";
        wait for 10 ns;
        
        t_fpla_in <= "100111001";
        wait for 10 ns;
        
        t_fpla_in <= "101010001";
        wait for 10 ns;
        
        t_fpla_in <= "010101011";
        wait for 10 ns;
        
        t_fpla_in <= "100000111";
        wait for 10 ns;
        
        t_fpla_in <= "111111111";
        wait for 10 ns;
        
        t_fpla_in <= "010011000";
        wait for 10 ns;

    end process test_process;

end fpla_test_mode;