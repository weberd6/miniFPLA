library ieee;
use ieee.std_logic_1164.all;

entity tb_plu_test_mode is
end entity tb_plu_test_mode;

architecture tb_behav of tb_plu_test_mode is
    component plu
        port (
            inp1, inp2 : in std_logic;
            outp : out std_logic;
            config : in std_logic;
            test : in std_logic;
            lut_shift_in : in std_logic;
            lut_shift_out : out std_logic;
            mux_ctrl_shift_in : in std_logic;
            mux_ctrl_shift_out : out std_logic;
            pstate_ff_shift_in : in std_logic;
            pstate_ff_shift_out : out std_logic;
            reset : in std_logic;
            clk : in std_logic
        );
    end component;
    
    signal t_inp1, t_inp2, t_outp, t_config, t_test, t_lut_shift_in, t_lut_shift_out, t_mux_ctrl_shift_in, t_mux_ctrl_shift_out,
      t_pstate_ff_shift_in, t_pstate_ff_shift_out, t_clk : std_logic := '0';
      
    signal t_reset : std_logic := '1';
    
begin
    plu1: plu port map(
                    t_inp1, t_inp2,
                    t_outp,
                    t_config,
                    t_test,
                    t_lut_shift_in,
                    t_lut_shift_out,
                    t_mux_ctrl_shift_in,
                    t_mux_ctrl_shift_out,
                    t_pstate_ff_shift_in,
                    t_pstate_ff_shift_out,
                    t_reset,
                    t_clk);

    clock_process : process
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
        t_test <= '1';
        wait for 5 ns;
        
        t_lut_shift_in <= '1';
        wait for 10 ns;
        
        t_lut_shift_in <= '0';
        wait for 10 ns;
        
        t_lut_shift_in <= '1';
        wait for 10 ns;
        
        t_lut_shift_in <= '0';
        wait for 10 ns;
        
        t_lut_shift_in <= '1';
        wait for 10 ns;
        
        t_lut_shift_in <= '0';
        wait for 10 ns;


        t_mux_ctrl_shift_in <= '1';
        wait for 10 ns;
        
        t_mux_ctrl_shift_in <= '0';
        wait for 10 ns;
        
        t_mux_ctrl_shift_in <= '1';
        wait for 10 ns;
        
        t_mux_ctrl_shift_in <= '0';
        wait for 10 ns;
        
        t_mux_ctrl_shift_in <= '1';
        wait for 10 ns;
        
        t_mux_ctrl_shift_in <= '0';
        wait for 10 ns;
        
    
        t_pstate_ff_shift_in <= '1';
        wait for 10 ns;
        
        t_pstate_ff_shift_in <= '0';
        wait for 10 ns;
        
        t_pstate_ff_shift_in <= '1';
        wait for 10 ns;
        
        t_pstate_ff_shift_in <= '0';
        wait for 10 ns;
        
        t_pstate_ff_shift_in <= '1';
        wait for 10 ns;
        
        t_pstate_ff_shift_in <= '0';
        wait for 10 ns;
        
    end process test_process;

end tb_behav;