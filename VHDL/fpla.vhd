library ieee;
use ieee.std_logic_1164.all;

entity fpla is
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
    
    component inverter
        port(
            inp   : in std_logic;
            outp  : out std_logic
        );
    end component;

    signal config_or_test : std_logic;

    signal plu_out : std_logic_vector((R*C-1) downto 0);

    signal lut_shift : std_logic_vector(((R+1)*C-1) downto 0);

    signal mux_ctrl_shift : std_logic_vector((R*C+R/2-1) downto 0);

    signal pstate_shift : std_logic_vector((R*C+R/2-1) downto 0);
    
    signal fpla_not_out : std_logic_vector(R+C-1 downto 0);

begin

    or1: orgate port map(
        inp1 => config,
        inp2 => normal_test,
        outp => config_or_test
    );

    gen_fpla_cols: for i in 0 to (C-1) generate
        gen_fpla_rows : for j in 0 to (R-1) generate

            not_input_plus: if (not ((i = 0) and ((j mod 2) = 0))
                        and not ((j = 0) and ((i mod 2) = 0))
                        and not ((i = (C-1)) and ((j mod 2) = 1))
                        and not ((j = (R-1)) and ((i mod 2) = 1)))
            generate

                even_row_even_column: if ((j mod 2 = 0) and (i mod 2 = 0)) generate
                    plu_ij: plu port map(
                        inp1 => plu_out(j*C + i - 1),
                        inp2 => plu_out((j-1)*C + i),
                        outp => plu_out(j*C + i),
                        config => config,
                        test => normal_test,
                        lut_shift_in => lut_shift((R+1)*i + j),
                        lut_shift_out => lut_shift((R+1)*i + j + 1),
                        mux_ctrl_shift_in => mux_ctrl_shift(C*j + j/2 + i),
                        mux_ctrl_shift_out => mux_ctrl_shift(C*j + j/2 + i + 1),
                        pstate_ff_shift_in => pstate_shift(C*(j+1) + j/2 - i - 1),
                        pstate_ff_shift_out => pstate_shift(C*(j+1) + j/2 - i),
                        reset => reset,
                        clk => clk
                    );
                end generate even_row_even_column;
            
                even_row_odd_column: if ((j mod 2 = 0) and (i mod 2 = 1)) generate
                    plu_ij: plu port map(
                        inp1 => plu_out((j+1)*C + 1),
                        inp2 => plu_out(j*C + i - 1),
                        outp => plu_out(j*C + i),
                        config => config,
                        test => normal_test,
                        lut_shift_in => lut_shift((R+1)*i + j),
                        lut_shift_out => lut_shift((R+1)*i + j + 1),
                        mux_ctrl_shift_in => mux_ctrl_shift(C*j + j/2 + i),
                        mux_ctrl_shift_out => mux_ctrl_shift(C*j + j/2 + i + 1),
                        pstate_ff_shift_in => pstate_shift(C*(j+1) + j/2 - i - 1),
                        pstate_ff_shift_out => pstate_shift(C*(j+1) + j/2 - i),
                        reset => reset,
                        clk => clk
                    );
                end generate even_row_odd_column;
            
                odd_row_even_column: if ((j mod 2 = 1) and (i mod 2 = 0)) generate
                    plu_ij: plu port map(
                        inp1 => plu_out(j*C + i + 1),
                        inp2 => plu_out(((j-1)*C + i),
                        outp => plu_out(j*C + i),
                        config => config,
                        test => normal_test,
                        lut_shift_in => lut_shift((R+1)*i + j),
                        lut_shift_out =>lut_shift((R+1)*i + j + 1) ,
                        mux_ctrl_shift_in => mux_ctrl_shift(C*(j-1) + (j-1)/2 - i - 1),
                        mux_ctrl_shift_out => mux_ctrl_shift(C*(j-1) + (j-1)/2 - i),
                        pstate_ff_shift_in => pstate_shift(C*j + (j-1)/2 + i),
                        pstate_ff_shift_out => pstate_shift(C*j + (j-1)/2 + i + 1),
                        reset => reset,
                        clk => clk
                    );
                end generate odd_row_even_column;
            
                odd_row_odd_column: if ((j mod 2 = 1) and (i mod 2 = 1)) generate
                    plu_ij: plu port map(
                        inp1 => plu_out((j+1)*C + 1),
                        inp2 => plu_out(j*C + i + 1),
                        outp => plu_out(j*C + i),
                        config => config,
                        test => normal_test,
                        lut_shift_in => lut_shift((R+1)*i + j),
                        lut_shift_out => lut_shift((R+1)*i + j + 1),
                        mux_ctrl_shift_in => mux_ctrl_shift(C*(j-1) + (j-1)/2 - i - 1),
                        mux_ctrl_shift_out => mux_ctrl_shift(C*(j-1) + (j-1)/2 - i),
                        pstate_ff_shift_in => pstate_shift(C*j + (j-1)/2 + i),
                        pstate_ff_shift_out => pstate_shift(C*j + (j-1)/2 + i + 1),
                        reset => reset,
                        clk => clk
                    );
                end generate odd_row_odd_column;
                
            end generate not_input_plus;

            input_demuxes_and_plus: if (((i = 0) and ((j mod 2) = 0))
                            or ((j = 0) and ((i mod 2) = 0))
                            or ((i = (C-1)) and ((j mod 2) = 1))
                            or ((j = (R-1)) and ((i mod 2) = 1)))
            generate
                plu_ij: plu port map(
                    inp1 => ,
                    inp2 => ,
                    outp => plu_out(j*C + i),
                    config => config,
                    test => normal_test,
                    lut_shift_in => lut_shift((R+1)*i + j),
                    lut_shift_out => lut_shift((R+1)*i + j + 1),
                    mux_ctrl_shift_in => mux_ctrl_shift(C*(j-1) + (j-1)/2 - i - 1),
                    mux_ctrl_shift_out => mux_ctrl_shift(C*(j-1) + (j-1)/2 - i),
                    pstate_ff_shift_in => pstate_shift(C*j + (j-1)/2 + i),
                    pstate_ff_shift_out => pstate_shift(C*j + (j-1)/2 + i + 1),
                    reset => reset,
                    clk => clk
                );
                    
                demux_ij: port map(
                    a => ,
                    s => ,
                    b => ,
                    c => 
                );
                    
            end generate input_demuxes_and_plus;
            
            output_muxes: if (((i = 0) and ((j mod 2) = 1))
                            or ((j = 0) and ((i mod 2) = 1))
                            or ((i = (C-1)) and ((j mod 2) = 0))
                            or ((j = (R-1)) snd ((i mod 2) = 0)))
            generate
                mux_ij: port map(
                    a => ,
                    b => ,
                    s => ,
                    c => 
                );
                
                not_ij: port map(
                  inp => ,
                  outp => 
                );  
            end generate output_muxes;

        end generate gen_fpla_rows;
    end generate gen_fpla_cols;

end fpla_structural;

