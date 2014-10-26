library ieee;
use ieee.std_logic_1164.all;

entity fpla is
    generic(m : Integer := 2);
    port(
        clk : in std_logic;
        reset : in std_logic;
        config : in std_logic;
        normal_test : in std_logic;
        fpla_in : in std_logic_vector(2*m-1 downto 0);
        fpla_out : out std_logic_vector(2*m-1 downto 0)
    );
end entity fpla;

architecture fpla_structural of fpla is
    component orgate
        port(
            inp1, inp2 : in std_logic;
            outp       : out std_logic);
    end component;

    component mux is
        port (
            a,b : in  std_logic;
            s   : in  std_logic;
            c   : out std_logic);
    end component;

    component demux is
        port (
            a   : in  std_logic;
            s   : in  std_logic;
            b,c : out std_logic);
    end component;

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
    end component plu;

    signal config_or_test : std_logic;

    signal left_inout_a, left_inout_b, top_inout_a, top_inout_b, right_inout_a, right_inout_b,
        bottom_inout_a, bottom_inout_b : std_logic_vector((m-1) downto 0);

    signal plu_out : std_logic_vector((m*m -1) downto 0);

    signal lut_shift : std_logic_vector(((m-1)*m-1) downto 0);

    signal mux_ctrl_shift : std_logic_vector((m*m-m/2-1) downto 0);

    signal pstate_shift : std_logic_vector((m*m-m/2-1) downto 0);

begin

    or1: orgate port map(
        inp1 => config,
        inp2 => normal_test,
        outp => config_or_test
    );

    gen_fpla_cols: for i in 0 to (m-1) generate
        gen_fpla_rows : for j in 0 to (m-1) generate

            top_left_corner: if ((i = 0) and (j = 0)) generate
                plu_ij: plu port map(
                    inp1 => left_inout_a(0),
                    inp2 => top_inout_a(0),
                    outp => plu_out(m*j+i),
                    config => config,
                    test => normal_test,
                    lut_shift_in => top_inout_b(0),
                    lut_shift_out => lut_shift(0),
                    mux_ctrl_shift_in => left_inout_b(0),
                    mux_ctrl_shift_out => mux_ctrl_shift(0),
                    pstate_ff_shift_in => pstate_shift(m*m-m/2-m),
                    pstate_ff_shift_out => pstate_shift(m*m-m/2-m+1),
                    reset => reset,
                    clk => clk
                );

                -- left demux
                demux_ij0: demux port map(
                    a => fpla_in(2*m-1),
                    s => config_or_test,
                    b => left_inout_a(0),
                    c => left_inout_b(0)
                );

                -- top demux
                demux_ji1: demux port map(
                    a => fpla_in(0),
                    s => config_or_test,
                    b => top_inout_a(0),
                    c => top_inout_b(0)
                );
            end generate top_left_corner;

            top_right_corner: if ((i = (m-1)) and (j = 0)) generate
                plu_ij: plu port map(
                    inp1 => plu_out((j+1)*m+i),
                    inp2 => plu_out(j*m+(i-1)),
                    outp => plu_out(j*m+i),
                    config => config,
                    test => normal_test,
                    lut_shift_in => lut_shift(m-1),
                    lut_shift_out => top_inout_b(m-1),
                    mux_ctrl_shift_in => mux_ctrl_shift(m-2),
                    mux_ctrl_shift_out => mux_ctrl_shift(m-1),
                    pstate_ff_shift_in => pstate_shift(m*m-m/2-1),
                    pstate_ff_shift_out => right_inout_b(0),
                    reset => reset,
                    clk => clk
                );

                -- top mux
                mux_ij: mux port map(
                    a => top_inout_a(m-1),
                    b => top_inout_b(m-1),
                    s => config_or_test,
                    c => fpla_out(m/2-1)
                );

                -- right mux
                mux_ji: mux port map(
                    a => right_inout_a(0),
                    b => right_inout_b(0),
                    s => config_or_test,
                    c => fpla_out(m/2)
                );
                
                top_inout_a(m-1) <= plu_out(j*m+i);
                right_inout_a(0) <= plu_out(j*m+i);
            end generate top_right_corner;

            bottom_left_corner: if ((i = 0) and (j = (m-1))) generate
                plu_ij: plu port map(
                    inp1 => plu_out(j*m+(i+1)),
                    inp2 => plu_out((j-1)*m+i),
                    outp => plu_out(j*m+i),
                    config => config,
                    test => normal_test,
                    lut_shift_in => lut_shift((m-1)*(m-1)-1),
                    lut_shift_out => bottom_inout_b(0),
                    mux_ctrl_shift_in => mux_ctrl_shift(m*m-m/2-1),
                    mux_ctrl_shift_out => left_inout_b(m-1),
                    pstate_ff_shift_in => pstate_shift(m-2),
                    pstate_ff_shift_out => pstate_shift(m-1),
                    reset => reset,
                    clk => clk
                );

                -- bottom mux
                mux_ij: mux port map(
                    a => bottom_inout_a(0),
                    b => bottom_inout_b(0),
                    s => config_or_test,
                    c => fpla_out(2*m-m/2-1)
                );

                -- left mux
                mux_ji: mux port map(
                    a => left_inout_a(m-1),
                    b => left_inout_b(m-1),
                    s => config_or_test,
                    c => fpla_out(2*m-m/2)
                );
                
                left_inout_a(m-1) <= plu_out(j*m+i);
                bottom_inout_a(0) <= plu_out(j*m+i);
            end generate bottom_left_corner;

            bottom_right_corner: if((i = (m-1)) and (j = (m-1))) generate
                plu_ij: plu port map(
                    inp1 => bottom_inout_a(m-1),
                    inp2 => right_inout_a(m-1),
                    outp => plu_out(j*m+i),
                    config => config,
                    test => normal_test,
                    lut_shift_in => bottom_inout_b(m-1),
                    lut_shift_out => lut_shift(m*(m-1)-1),
                    mux_ctrl_shift_in => mux_ctrl_shift(m*m-m/2-m),
                    mux_ctrl_shift_out => mux_ctrl_shift(m*m-m/2-m+1),
                    pstate_ff_shift_in => right_inout_b(m-1),
                    pstate_ff_shift_out => pstate_shift(0),
                    reset => reset,
                    clk => clk
                );

                -- right demux
                demux_ij0: demux port map(
                    a => fpla_in(m-1),
                    s => config_or_test,
                    b => right_inout_a(m-1),
                    c => right_inout_b(m-1)
                );

                -- bottom demux
                demux_ji1: demux port map(
                    a => fpla_in(m),
                    s => config_or_test,
                    b => bottom_inout_a(m-1),
                    c => bottom_inout_b(m-1)
                );
            end generate bottom_right_corner;


            -- TODO, come back to this later, right now assume 2x2
            top_mid_plus: if ((j = 0) and (i /= 0) and (i /= (m-1))) generate
            end generate top_mid_plus;

            bottom_mid_plus : if ((j = (m-1)) and (i /= 0) and (i /= (m-1))) generate
            end generate bottom_mid_plus;

            left_mid_plus: if ((i = 0) and (j /= 0) and (j /= (m-1))) generate
            end generate left_mid_plus;

            right_mid_plus: if ((i = (m-1)) and (j /= 0) and (j /= (m-1))) generate
            end generate right_mid_plus;

            mid_mid_plus: if((i > 0) and (i < (m-1)) and (j > 0) and (j < (m-1))) generate
            end generate mid_mid_plus;

        end generate gen_fpla_rows;
    end generate gen_fpla_cols;

end fpla_structural;

