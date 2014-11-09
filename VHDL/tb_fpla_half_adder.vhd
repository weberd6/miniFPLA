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
            fpla_in : in std_logic_vector(R+C-1 downto 0);
            fpla_out : out std_logic_vector(R+C-1 downto 0)
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
      
        -- Configure to be half adder
        wait for 7.5 ns;
        
        t_reset <= '0';
        t_config <= '1';
        wait for 5 ns;

        t_fpla_in <= "0101";
        wait for 10 ns;

        t_fpla_in <= "0001";
        wait for 10 ns;

        t_fpla_in <= "0100";
        wait for 10 ns;

        t_fpla_in <= "0000";
        wait for 10 ns;

        t_fpla_in <= "0100";
        wait for 10 ns;

        t_fpla_in <= "0001";
        wait for 20 ns;

        t_fpla_in <= "0000";
        wait for 10 ns;

        t_config <= '0';
        wait for 10 ns;


        -- Test half adder
        -- A = fpla_in(0) and fpla_in(1)
        -- B = fpla_in(2) and fpla_in(3)
        -- C = fpla_out(2) and fpla_out(3)
        -- S = fpla_out(0) and fpla_out(1)

        t_fpla_in <= "0011";
        wait for 10 ns;
        
        t_fpla_in <= "0000";
        wait for 10 ns;
        
        t_fpla_in <= "1100";
        wait for 10 ns;
        
        t_fpla_in <= "0011";
        wait for 10 ns;
        
        t_fpla_in <= "0000";
        wait for 10 ns;
        
        t_fpla_in <= "1111";
        wait for 10 ns;
        
        t_fpla_in <= "0011";
        wait for 10 ns;
        
        t_fpla_in <= "1111";
        wait for 10 ns;
        
        t_fpla_in <= "1100";
        wait for 10 ns;
        
        t_fpla_in <= "1111";
        wait for 10 ns;
        
        t_fpla_in <= "0000";
        wait for 10 ns;
        
        wait;
    end process test_process;

end fpla_half_adder;

