library ieee;
use ieee.std_logic_1164.all;

entity plu is
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
end entity plu;

architecture plu_structural of plu is

    component orgate
        port(
            inp1, inp2 : in std_logic;
            outp       : out std_logic);
    end component;

    component lut
        port (
            inp1, inp2 : in std_logic;
            outp : out std_logic;
            lut_shift_in : in std_logic;
            lut_shift_out : out std_logic;
            reset : in std_logic;
            clk : in std_logic;
            ld : in std_logic);
    end component;

    component Df_f
        port (Q : out std_logic;
              CLK : in std_logic;
              CE : in std_logic;
              RESET : in std_logic;
              D : in std_logic);
    end component;

    component mux
        port (a, b : in std_logic;
              s : in std_logic;
              c : out std_logic);
    end component;

    signal ld, lut_out, ff_in, ff_out, ld_mux_q, out_mux_q, config_or_test : std_logic;

begin

    or0: orgate port map (
        inp1 => config,
        inp2 => test,
        outp => config_or_test);

    lut0: lut port map (
        inp1 => inp1,
        inp2 => inp2,
        outp => lut_out,
        lut_shift_in => lut_shift_in,
        lut_shift_out => lut_shift_out,
        reset => reset,
        clk => clk,
        ld => config_or_test);

    pstate_ff: Df_f port map (
        Q => ff_out,
        CLK => clk,
        CE => ld,
        RESET => reset,
        D => ff_in);

    load_mux_ff: Df_f port map (
        Q => ld_mux_q,
        CLK => clk,
        CE => config_or_test,
        RESET => reset,
        D => mux_ctrl_shift_in);

    out_mux_ff: Df_f port map (
        Q => out_mux_q,
        CLK => clk,
        CE => config_or_test,
        RESET => reset,
        D => ld_mux_q);

    test_mux: mux port map (
        a => lut_out,
        b => pstate_ff_shift_in,
        s => test,
        c => ff_in);

    load_mux: mux port map (
        a => inp1,
        b => inp2,
        s => ld_mux_q,
        c => ld);

    out_mux: mux port map (
        a => lut_out,
        b => ff_out,
        s => out_mux_q,
        c => outp);

    mux_ctrl_shift_out <= out_mux_q;
    pstate_ff_shift_out <= ff_out;

end plu_structural;
