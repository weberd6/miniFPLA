library ieee;
use ieee.std_logic_1164.all;

entity lut is
    port (
        inp1, inp2 : in std_logic;
        outp : out std_logic;
        lut_shift_in : in std_logic;
        lut_shift_out : out std_logic;
        reset : in std_logic;
        clk : in std_logic;
        ld : in std_logic);
end entity lut;

architecture lut_structural of lut is
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

    signal lut_ff_q : std_logic_vector(3 downto 0);
    signal lut_mux : std_logic_vector(1 downto 0);

begin

    lut00: Df_f port map (
        Q => lut_ff_q(0),
        CLK => clk,
        CE => ld,
        RESET => reset,
        D => lut_shift_in);

    lut01: Df_f port map (
        Q => lut_ff_q(1),
        CLK => clk,
        CE => ld,
        RESET => reset,
        D => lut_ff_q(0));

    lut10: Df_f port map (
        Q => lut_ff_q(2),
        CLK => clk,
        CE => ld,
        RESET => reset,
        D => lut_ff_q(1));

    lut11: Df_f port map (
        Q => lut_ff_q(3),
        CLK => clk,
        CE => ld,
        RESET => reset,
        D => lut_ff_q(2));

    mux_lut2_1: mux port map (
        a => lut_ff_q(0),
        b => lut_ff_q(1),
        s => inp2,
        c => lut_mux(0));

    mux_lut2_2: mux port map (
        a => lut_ff_q(2),
        b => lut_ff_q(3),
        s => inp2,
        c => lut_mux(1));

    mux_lut1: mux port map (
        a => lut_mux(0),
        b => lut_mux(1),
        s => inp1,
        c => outp);

    lut_shift_out <= lut_ff_q(3);

end lut_structural;
