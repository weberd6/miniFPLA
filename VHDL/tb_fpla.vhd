library ieee;
use ieee.std_logic_1164.all;

entity tb_fpla is
end entity tb_fpla;

architecture test_fpla of tb_fpla is
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
    
    signal t_clk, t_config, t_normal_test, t_fpla_in, t_fpla_out : std_logic := '0';

    signal t_reset : std_logic :=  '1';
    
begin

    fpla0: fpla generic map(2)
              port map(
                clk <= t_clk,
                reset <= t_reset,
                config <= t_config,
                normal_test <= t_normal_test,
                fpla_in <= t_fpla_in,
                fpla_out <= t_fpla_out);

    clock_process: process
    begin
        clk_loop: loop
            wait for 5 ns;
            t_clk <= not t_clk;
        end loop clk_loop;
    end process clock_process;

    test_process: process
    begin
        
    end process;

end test_fpla;

