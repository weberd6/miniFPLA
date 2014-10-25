library ieee;
use ieee.std_logic_1164.all;

entity fpla is
    generic(m : Integer := 2)
    port(
        clk : in std_logic;
        reset : in std_logic;
        config : in std_logic;
        normal_test : in std_logic;
        fpla_in in : std_logic_vector(2*m-1 downto 0);
        fpla_out out : std_logic_vector(2*m-1 downto 0)
    );
end entity fpla;

architecture fpla_structural of fpla is
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
    component plu;

    signal config_or_test : std_logic;

    signal left_inout_a, left_inout_b, top_inout_a, top_inout_b, right_inout_a, right_inout_b,
        bottom_inout_a, bottom_inout_b : std_logic_vector((m-1) downto 0);

    signal plu_out : std_logic_vector((m*m -1) down to 0);

    signal lut_shift : std_logic_vector(((m-1)*m-1) downto 0);

begin

    gen_fpla_cols: for i in 0 to (m-1) generate
        gen_fpla_rows : for j in 0 to (m-1) generate

            top_left_corner: if ((i = 0) and (j = 0)) generate
                plu_ij: plu port map(
                    inp1 => left_inout_a(j),
                    inp2 => top_inout_a(i),
                    outp => plu_out(m*j+i),
                    config => config,
                    test => test,
                    lut_shift_in => top_inout_b(i),
                    lut_shift_out => ,
                    mux_ctrl_shift_in => left_inout_b(j),
                    mux_ctrl_shift_out => ,
                    pstate_ff_shift_in =>,
                    pstate_ff_shift_out =>,
                    reset => reset,
                    clk => clk
                );

                demux_ij0: demux port map(
                    a => left_inout_a(j),
                    s => config_or_test,
                    b => left_inout_b(j),
                    c => fpla_in(0)
                );

                demux_ji1: demux port map(
                    a => top_inout_a(i),
                    s => config_or_test,
                    b => top_inout_a(i),
                    c => fpla_in(1)
                );
            end generate top_left_corner;

            top_right_corner: if ((i = (m-1)) and (j = 0)) generate
                plu_ij: plu port map(
                    inp1 =>,
                    inp2 =>,
                    outp =>,
                    config =>,
                    test =>,
                    lut_shift_in =>,
                    lut_shift_out =>,
                    mux_ctrl_shift_in =>,
                    mux_ctrl_shift_out =>,
                    pstate_ff_shift_in =>,
                    pstate_ff_shift_out =>,
                    reset =>,
                    clk =>
                );

                mux_ij: mux port map(
                    a => ,
                    b => ,
                    s => ,
                    c => 
                );

                mux_ji: mux port map(
                    a => ,
                    b => ,
                    s => ,
                    c => 
                );
            end generate top_right_corner;

            bottom_left_corner: if ((i = 0) and (j = (m-1))) generate
                plu_ij: plu port map(
                    inp1 =>,
                    inp2 =>,
                    outp =>,
                    config =>,
                    test =>,
                    lut_shift_in =>,
                    lut_shift_out =>,
                    mux_ctrl_shift_in =>,
                    mux_ctrl_shift_out =>,
                    pstate_ff_shift_in =>,
                    pstate_ff_shift_out =>,
                    reset =>,
                    clk =>
                );

                mux_ij: mux port map(
                    a => ,
                    b => ,
                    s => ,
                    c => 
                );

                mux_ji: mux port map(
                    a => ,
                    b => ,
                    s => ,
                    c => 
                );
            end generate bottom_left_corner;

            bottom_right_corner: if((i = (m-1)) and (j = (m-1))) generate
                plu_ij: plu port map(
                    inp1 =>,
                    inp2 =>,
                    outp =>,
                    config =>,
                    test =>,
                    lut_shift_in =>,
                    lut_shift_out =>,
                    mux_ctrl_shift_in =>,
                    mux_ctrl_shift_out =>,
                    pstate_ff_shift_in =>,
                    pstate_ff_shift_out =>,
                    reset =>,
                    clk =>
                );

                demux_ij0: demux port map(
                    a => ,
                    s => ,
                    b => ,
                    c => 
                );

                demux_ji1: demux port map(
                    a => ,
                    s => ,
                    b => ,
                    c => 
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

            mid_mid_plus: if((i > 0) and (i < (n-1)) and (j > 0) and (j < (n-1))) generate
            end generate mid_mid_plus;

        end generate gen_fpla_rows;
    end generate gen_fpla_cols;

end fpla_structural;

