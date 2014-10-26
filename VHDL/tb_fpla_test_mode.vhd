library ieee;
use ieee.std_logic_1164.all;

entity tb_fpla_test_mode is
end entity tb_fpla_test_mode;

architecture fpla_test_mode of tb_fpla_test_mode is
    component fpla
        generic(m : Integer := 2);
        port(
            clk : in std_logic;
            reset : in std_logic;
            config : in std_logic;
            normal_test : in std_logic;
            fpla_in : in std_logic_vector(2*m-1 downto 0);
            fpla_out : out std_logic_vector(2*m-1 downto 0)
        );
    end component;
    
    constant m_tb : integer := 2;
    
    signal t_clk, t_config, t_normal_test : std_logic := '0';
    
    signal t_fpla_in, t_fpla_out : std_logic_vector(2*m_tb-1 downto 0) := "0000";

    signal t_reset : std_logic :=  '1';
    
begin

    fpla0: fpla generic map(m_tb)
              port map(
                clk => t_clk,
                reset => t_reset,
                config => t_config,
                normal_test => t_normal_test,
                fpla_in => t_fpla_in,
                fpla_out => t_fpla_out);

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
        
        t_fpla_in <= "1111";
        wait for 10 ns;
        
        t_fpla_in <= "1010";
        wait for 10 ns;
        
        t_fpla_in <= "1100";
        wait for 10 ns;
        
        t_fpla_in <= "0000";
        wait for 10 ns;
        
        t_fpla_in <= "0110";
        wait for 10 ns;
        
        t_fpla_in <= "1001";
        wait for 10 ns;
        
        t_fpla_in <= "0100";
        wait for 10 ns;
        
        t_fpla_in <= "0111";
        wait for 10 ns;
        
        t_fpla_in <= "0110";
        wait for 10 ns;
        
        t_fpla_in <= "1011";
        wait for 10 ns;
        
        t_fpla_in <= "0111";
        wait for 10 ns;
        
        t_fpla_in <= "1010";
        wait for 10 ns;
        
        t_fpla_in <= "1001";
        wait for 10 ns;
        
        t_fpla_in <= "1010";
        wait for 10 ns;
        
        t_fpla_in <= "0101";
        wait for 10 ns;
        
        t_fpla_in <= "1000";
        wait for 10 ns;
        
        t_fpla_in <= "1111";
        wait for 10 ns;
        
        t_fpla_in <= "0100";
        wait for 10 ns;

    end process test_process;

end fpla_test_mode;