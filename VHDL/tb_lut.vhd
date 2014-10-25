library ieee;
use ieee.std_logic_1164.all;

entity tb_lut is
end entity tb_lut;

architecture tb_behav of tb_lut is
    component lut
        port(
            inp1, inp2 : in std_logic;
            lut_shift_in : in std_logic;
            reset : in std_logic;
            clk : in std_logic;
            ld : in std_logic;
            outp : out std_logic;
            lut_shift_out : out std_logic
        );
    end component;
    
    signal  t_inp1, t_inp2, t_lut_shift_in, t_clk, t_ld, t_outp, t_lut_shift_out: std_logic := '0';
    signal  t_reset : std_logic := '1';
    
begin
    U1 :  lut port map(t_inp1, t_inp2, t_lut_shift_in, t_reset, t_clk, t_ld, t_outp, t_lut_shift_out);

    clock_process : process
    begin
        clk_loop: loop
            wait for 5 ns;
            t_clk <= not t_clk;
        end loop clk_loop;
    end process clock_process;

    test_process  : process 
    begin
        -- Shift OR gate into LUT
        wait for 12.5 ns;
        
        t_reset <= '0';
        t_ld <= '1';
        t_lut_shift_in <= '1';
        wait for 10 ns;
        
        t_lut_shift_in <= '0';
        wait for 10 ns;
        
        t_lut_shift_in <= '1';
        wait for 10 ns;
        
        t_lut_shift_in <= '0';
        wait for 10 ns;
        
        t_lut_shift_in <= '1';
        wait for 30 ns;

        t_lut_shift_in <= '0';
        wait for 5 ns;
        
        t_ld <= '0';
        wait for 20 ns;
        
        
        -- Test OR gate
        t_inp2 <= '1';
        wait for 5 ns;
        
        t_inp2 <= '0';
        t_inp1 <= '1';
        wait for 5 ns;
        
        t_inp2 <= '1';
        wait for 15 ns;
        
        
        -- Shift in 2 more 0's to get AND gate in LUT
        t_ld <= '1';
        t_lut_shift_in <= '0';
        wait for 15 ns;
        
        t_ld <= '0';
        wait for 20 ns;


        -- Test AND gate
        t_inp2 <= '0';
        t_inp1 <= '0';
        wait for 5 ns;
        
        t_inp2 <= '1';
        wait for 5 ns;
        
        t_inp2 <= '0';
        t_inp1 <= '1';
        wait for 5 ns;
        
        t_inp2 <= '1';
        wait for 15 ns;

        wait;          
    end process test_process;        
end tb_behav;

