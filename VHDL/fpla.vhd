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
    
    signal plu_in : std_logic_vector((R+C-1) downto 0);

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

            mid_plus: if ((i /= 0) and (j /= 0) and (i /= (C-1)) and (j /= (R-1))) generate

                even_row_even_column: if (((j mod 2) = 0) and ((i mod 2) = 0)) generate
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
            
                even_row_odd_column: if (((j mod 2) = 0) and ((i mod 2) = 1)) generate
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
            
                odd_row_even_column: if (((j mod 2) = 1) and ((i mod 2) = 0)) generate
                    plu_ij: plu port map(
                        inp1 => plu_out(j*C + i + 1),
                        inp2 => plu_out((j-1)*C + i),
                        outp => plu_out(j*C + i),
                        config => config,
                        test => normal_test,
                        lut_shift_in => lut_shift((R+1)*i + j),
                        lut_shift_out => lut_shift((R+1)*i + j + 1),
                        mux_ctrl_shift_in => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i - 1),
                        mux_ctrl_shift_out => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i),
                        pstate_ff_shift_in => pstate_shift(C*j + (j-1)/2 + i),
                        pstate_ff_shift_out => pstate_shift(C*j + (j-1)/2 + i + 1),
                        reset => reset,
                        clk => clk
                    );
                end generate odd_row_even_column;
            
                odd_row_odd_column: if (((j mod 2) = 1) and ((i mod 2) = 1)) generate
                    plu_ij: plu port map(
                        inp1 => plu_out((j+1)*C + 1),
                        inp2 => plu_out(j*C + i + 1),
                        outp => plu_out(j*C + i),
                        config => config,
                        test => normal_test,
                        lut_shift_in => lut_shift((R+1)*i + j),
                        lut_shift_out => lut_shift((R+1)*i + j + 1),
                        mux_ctrl_shift_in => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i - 1),
                        mux_ctrl_shift_out => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i),
                        pstate_ff_shift_in => pstate_shift(C*j + (j-1)/2 + i),
                        pstate_ff_shift_out => pstate_shift(C*j + (j-1)/2 + i + 1),
                        reset => reset,
                        clk => clk
                    );
                end generate odd_row_odd_column;
                
            end generate mid_plus;
            
            outer_plus: if ((i = 0) or (j = 0) or (i = (C-1)) or (j = (R-1))) generate
                
                top_left_corner: if ((i = 0) and (j = 0)) generate
                    plu_ij: plu port map(
                        inp1 => plu_in(R+C-1),
                        inp2 => plu_in(0),
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
                end generate top_left_corner;
                
                bottom_left_corner: if ((i = 0) and (j = (R-1))) generate
                    plu_ij: plu port map(
                            inp1 => plu_out(j*C + i + 1),
                            inp2 => plu_out((j-1)*C + i),
                            outp => plu_out(j*C + i),
                            config => config,
                            test => normal_test,
                            lut_shift_in => lut_shift((R+1)*i + j),
                            lut_shift_out =>lut_shift((R+1)*i + j + 1) ,
                            mux_ctrl_shift_in => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i - 1),
                            mux_ctrl_shift_out => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i),
                            pstate_ff_shift_in => pstate_shift(C*j + (j-1)/2 + i),
                            pstate_ff_shift_out => pstate_shift(C*j + (j-1)/2 + i + 1),
                            reset => reset,
                            clk => clk
                    );
                end generate bottom_left_corner;
                
                top_right_corner: if ((i = (C-1)) and (j = 0)) generate
                
                    odd_number_of_colums: if ((C mod 2) = 1) generate
                        plu_ij: plu port map(
                            inp1 => plu_out(j*C + i - 1),
                            inp2 => plu_in(i/2),
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
                    end generate odd_number_of_colums;
            
                    even_number_of_columns: if ((C mod 2) = 0) generate
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
                    end generate even_number_of_columns;
                    
                end generate top_right_corner;
                
                bottom_right_corner: if ((i = (C-1)) and (j = (R-1))) generate
                    
                    odd_number_of_colums: if ((C mod 2) = 1) generate
                        plu_ij: plu port map(
                            inp1 => plu_in((C-1)/2 + (j+1)/2),
                            inp2 => plu_out((j-1)*C + i),
                            outp => plu_out(j*C + i),
                            config => config,
                            test => normal_test,
                            lut_shift_in => lut_shift((R+1)*i + j),
                            lut_shift_out =>lut_shift((R+1)*i + j + 1) ,
                            mux_ctrl_shift_in => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i - 1),
                            mux_ctrl_shift_out => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i),
                            pstate_ff_shift_in => pstate_shift(C*j + (j-1)/2 + i),
                            pstate_ff_shift_out => pstate_shift(C*j + (j-1)/2 + i + 1),
                            reset => reset,
                            clk => clk
                        );
                    end generate odd_number_of_colums;
            
                    even_number_of_columns: if ((C mod 2) = 0) generate
                        plu_ij: plu port map(
                            inp1 => plu_in(R+C-1-R/2-i/2),
                            inp2 => plu_in((C-1)/2 + (j+1)/2),
                            outp => plu_out(j*C + i),
                            config => config,
                            test => normal_test,
                            lut_shift_in => lut_shift((R+1)*i + j),
                            lut_shift_out => lut_shift((R+1)*i + j + 1),
                            mux_ctrl_shift_in => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i - 1),
                            mux_ctrl_shift_out => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i),
                            pstate_ff_shift_in => pstate_shift(C*j + (j-1)/2 + i),
                            pstate_ff_shift_out => pstate_shift(C*j + (j-1)/2 + i + 1),
                            reset => reset,
                            clk => clk
                        );
                    end generate even_number_of_columns;
                    
                end generate bottom_right_corner;
                
                -- Top Inputs
                top_row_even_column: if ((j = 0) and ((i mod 2) = 0)) generate
                
                    if_not_left_corner: if (i /= 0) generate
                        plu_ij: plu port map(
                            inp1 => plu_out(j*C + i - 1),
                            inp2 => plu_in(i/2),
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
                    end generate if_not_left_corner;
                    
                    demux_ij: demux port map(
                        a => fpla_in(i/2),
                        s => config_or_test,
                        b => plu_in(i/2),
                        c => lut_shift((R+1)*i + j)
                    );
            
                end generate top_row_even_column;
                
                -- Bottom Inputs
                bottom_row_odd_column: if ((j = (R-1)) and ((i mod 2) = 1)) generate
                
                    if_not_right_corner: if (i /= (C-1)) generate
                        plu_ij: plu port map(
                            inp1 => plu_in(R+C-1-R/2-i/2),
                            inp2 => plu_out(j*C + i + 1),
                            outp => plu_out(j*C + i),
                            config => config,
                            test => normal_test,
                            lut_shift_in => lut_shift((R+1)*i + j),
                            lut_shift_out => lut_shift((R+1)*i + j + 1),
                            mux_ctrl_shift_in => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i - 1),
                            mux_ctrl_shift_out => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i),
                            pstate_ff_shift_in => pstate_shift(C*j + (j-1)/2 + i),
                            pstate_ff_shift_out => pstate_shift(C*j + (j-1)/2 + i + 1),
                            reset => reset,
                            clk => clk
                        );
                    end generate if_not_right_corner;
                    
                    demux_ij: demux port map(
                        a => fpla_in(R+C-1-R/2-i/2),
                        s => config_or_test,
                        b => plu_in(R+C-1-R/2-i/2),
                        c => lut_shift((R+1)*i + j)
                    );
                    
                end generate bottom_row_odd_column; 
                
                -- Left Input
                even_row_left_column: if (((j mod 2) = 0) and (i = 0)) generate
                
                    if_not_top_corner: if (j /= 0) generate
                        plu_ij: plu port map(
                            inp1 => plu_in(R+C-1-j/2),
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
                    end generate if_not_top_corner;
                    
                    demux_ij: demux port map(
                        a => fpla_in(R+C-1-j/2),
                        s => config_or_test,
                        b => plu_in(R+C-1-j/2),
                        c => mux_ctrl_shift(C*j + j/2 + i)
                    );
                    
                end generate even_row_left_column;
                
                -- Right Inputs
                odd_row_right_column: if (((j mod 2) = 1) and (i = (C-1))) generate
                
                    if_not_bottom_corner: if (j /= (R-1)) generate
                    
                        odd_number_of_colums: if ((C mod 2) = 1) generate
                            plu_ij: plu port map(
                                inp1 => plu_in((C-1)/2 + (j+1)/2),
                                inp2 => plu_out((j-1)*C + i),
                                outp => plu_out(j*C + i),
                                config => config,
                                test => normal_test,
                                lut_shift_in => lut_shift((R+1)*i + j),
                                lut_shift_out =>lut_shift((R+1)*i + j + 1) ,
                                mux_ctrl_shift_in => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i - 1),
                                mux_ctrl_shift_out => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i),
                                pstate_ff_shift_in => pstate_shift(C*j + (j-1)/2 + i),
                                pstate_ff_shift_out => pstate_shift(C*j + (j-1)/2 + i + 1),
                                reset => reset,
                                clk => clk
                            );
                        end generate odd_number_of_colums;
            
                        even_number_of_columns: if ((C mod 2) = 0) generate
                            plu_ij: plu port map(
                                inp1 => plu_out((j+1)*C + 1),
                                inp2 => plu_in((C-1)/2 + (j+1)/2),
                                outp => plu_out(j*C + i),
                                config => config,
                                test => normal_test,
                                lut_shift_in => lut_shift((R+1)*i + j),
                                lut_shift_out => lut_shift((R+1)*i + j + 1),
                                mux_ctrl_shift_in => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i - 1),
                                mux_ctrl_shift_out => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i),
                                pstate_ff_shift_in => pstate_shift(C*j + (j-1)/2 + i),
                                pstate_ff_shift_out => pstate_shift(C*j + (j-1)/2 + i + 1),
                                reset => reset,
                                clk => clk
                            );
                        end generate even_number_of_columns;
                        
                    end generate if_not_bottom_corner;
                    
                    demux_ij: demux port map(
                        a => fpla_in((C-1)/2 + (j+1)/2),
                        s => config_or_test,
                        b => plu_in((C-1)/2 + (j+1)/2),
                        c => pstate_shift(C*j + (j-1)/2 + i)
                    );
                    
                end generate odd_row_right_column;
                
                -- Top Outputs
                top_row_odd_column: if ((j = 0) and ((i mod 2) = 1)) generate
                
                    if_not_right_corner: if (i /= (C-1)) generate
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
                    end generate if_not_right_corner;
                    
                    mux_ij: mux port map(
                        a => plu_out(j*C + i),
                        b => lut_shift((R+1)*i + j + 1),
                        s => config_or_test,
                        c => fpla_not_out((i-1)/2)
                    );
                    
                    not_ij: inverter port map(
                        inp => fpla_not_out((i-1)/2),
                        outp => fpla_out((i-1)/2)
                    );
                    
                end generate top_row_odd_column;
                
                -- Bottom Outputs
                bottom_row_even_column: if ((j = (R-1)) and ((i mod 2) = 0)) generate
                
                    if_not_left_corner: if (i /= 0) generate
                        plu_ij: plu port map(
                            inp1 => plu_out(j*C + i + 1),
                            inp2 => plu_out((j-1)*C + i),
                            outp => plu_out(j*C + i),
                            config => config,
                            test => normal_test,
                            lut_shift_in => lut_shift((R+1)*i + j),
                            lut_shift_out => lut_shift((R+1)*i + j + 1),
                            mux_ctrl_shift_in => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i - 1),
                            mux_ctrl_shift_out => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i),
                            pstate_ff_shift_in => pstate_shift(C*j + (j-1)/2 + i),
                            pstate_ff_shift_out => pstate_shift(C*j + (j-1)/2 + i + 1),
                            reset => reset,
                            clk => clk
                        );
                    end generate if_not_left_corner;
                    
                    mux_ij: mux port map(
                        a => plu_out(j*C + i),
                        b => lut_shift((R+1)*i + j + 1),
                        s => config_or_test,
                        c => fpla_not_out(R+C-1-R/2-i/2)
                    );
                    
                    
                    not_ij: inverter port map(
                        inp => fpla_not_out(R+C-1-R/2-i/2),
                        outp => fpla_out(R+C-1-R/2-i/2)
                    );

                end generate bottom_row_even_column;
                
                -- Left Outputs
                odd_row_left_column: if (((j mod 2) = 1) and (i = 0)) generate
                
                    if_not_bottom_corner: if (j /= (R-1)) generate
                        plu_ij: plu port map(
                            inp1 => plu_out(j*C + i + 1),
                            inp2 => plu_out((j-1)*C + i),
                            outp => plu_out(j*C + i),
                            config => config,
                            test => normal_test,
                            lut_shift_in => lut_shift((R+1)*i + j),
                            lut_shift_out =>lut_shift((R+1)*i + j + 1) ,
                            mux_ctrl_shift_in => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i - 1),
                            mux_ctrl_shift_out => mux_ctrl_shift(C*(j+1) + (j-1)/2 - i),
                            pstate_ff_shift_in => pstate_shift(C*j + (j-1)/2 + i),
                            pstate_ff_shift_out => pstate_shift(C*j + (j-1)/2 + i + 1),
                            reset => reset,
                            clk => clk
                        );
                    end generate if_not_bottom_corner;
                    
                    mux_ij: mux port map(
                        a => plu_out(j*C + i),
                        b => mux_ctrl_shift(C*(j-1) + (j-1)/2 - i),
                        s => config_or_test,
                        c => fpla_not_out(R+C-1-(j-1)/2)
                    );
                    
                    not_ij: inverter port map(
                        inp => fpla_not_out(R+C-1-(j-1)/2),
                        outp => fpla_out(R+C-1-(j-1)/2)
                    );
                    
                end generate odd_row_left_column;
                
                -- Right Outputs
                even_row_right_column: if (((j mod 2) = 0) and (i = (C-1))) generate
                
                    if_not_top_corner: if (j /= 0) generate

                        odd_number_of_colums: if ((C mod 2) = 1) generate
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
                        end generate odd_number_of_colums;
                    
                        even_number_of_columns: if ((C mod 2) = 0) generate
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
                        end generate even_number_of_columns;
                        
                    end generate if_not_top_corner;
                    
                    mux_ij: mux port map(
                        a => plu_out(j*C + i),
                        b => pstate_shift(C*(j+1) + j/2 - i),
                        s => config_or_test,
                        c => fpla_not_out(C/2 + j/2)
                    );
                    
                    not_ij: inverter port map(
                        inp => fpla_not_out(C/2 + j/2),
                        outp => fpla_out(C/2 + j/2)
                    );
                    
                end generate even_row_right_column;
                
            end generate outer_plus;
            

        end generate gen_fpla_rows;
    end generate gen_fpla_cols;
    
end fpla_structural;

