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
        top_in : in std_logic_vector(((C + (C mod 2))/2 - 1) downto 0);
        left_in : in std_logic_vector(((R + (R mod 2))/2 - 1) downto 0);
        bottom_in : in std_logic_vector(((C - (C mod 2))/2 - 1) downto 0);
        right_in : in std_logic_vector(((R - (R mod 2))/2 - 1) downto 0);
        top_out : out std_logic_vector(((C - (C mod 2))/2 - 1) downto 0);
        left_out : out std_logic_vector(((R - (R mod 2))/2 - 1) downto 0);
        bottom_out : out std_logic_vector(((C + (C mod 2))/2 - 1) downto 0);
        right_out : out std_logic_vector(((R + (R mod 2))/2 - 1) downto 0)
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
    
    signal plu_in : std_logic_vector((2*R*C-1) downto 0);

    signal lut_shift : std_logic_vector(((R+1)*C-1) downto 0);

    signal mux_ctrl_shift : std_logic_vector(((C+1)*R-1) downto 0);

    signal pstate_shift : std_logic_vector(((C+1)*R-1) downto 0);
    
    signal top_out_not : std_logic_vector(((C - (C mod 2))/2 - 1) downto 0);
    
    signal left_out_not : std_logic_vector(((R - (R mod 2))/2 - 1) downto 0);
    
    signal bottom_out_not : std_logic_vector(((C + (C mod 2))/2 - 1) downto 0);
    
    signal right_out_not : std_logic_vector(((R + (R mod 2))/2 - 1) downto 0);

begin

    or1: orgate port map(
        inp1 => config,
        inp2 => normal_test,
        outp => config_or_test
    );

    gen_fpla_cols: for i in 0 to (C-1) generate
        gen_fpla_rows : for j in 0 to (R-1) generate

          even_row_even_column: if (((j mod 2) = 0) and ((i mod 2) = 0)) generate
              
              plu_ij: plu port map(
                  inp1 => plu_in(2*(j*C+i)),
                  inp2 => plu_in(2*(j*C+i)+1),
                  outp => plu_out(j*C + i),
                  config => config,
                  test => normal_test,
                  lut_shift_in => lut_shift(j*C+i),
                  lut_shift_out => lut_shift((j+1)*C+i),
                  mux_ctrl_shift_in => mux_ctrl_shift(j*(C+1)+i),
                  mux_ctrl_shift_out => mux_ctrl_shift(j*(C+1)+i+1),
                  pstate_ff_shift_in => pstate_shift(j*(C+1)+i),
                  pstate_ff_shift_out => pstate_shift(j*(C+1)+i+1),
                  reset => reset,
                  clk => clk
              );
              
              in1: if (i /= 0) generate
                  plu_in(2*(j*C+i)) <= plu_out(j*C+i-1);
              end generate;
              
              in2: if (j /= 0) generate
                  plu_in(2*(j*C+i)+1) <= plu_out((j-1)*C+i);
              end generate;
              
          end generate even_row_even_column;
          
          even_row_odd_column: if (((j mod 2) = 0) and ((i mod 2) = 1)) generate
              
              plu_ij: plu port map(
                  inp1 => plu_in(2*(j*C+i)),
                  inp2 => plu_in(2*(j*C+i)+1),
                  outp => plu_out(j*C + i),
                  config => config,
                  test => normal_test,
                  lut_shift_in => lut_shift((j+1)*C+i),
                  lut_shift_out => lut_shift(j*C+i),
                  mux_ctrl_shift_in => mux_ctrl_shift(j*(C+1)+i),
                  mux_ctrl_shift_out => mux_ctrl_shift(j*(C+1)+i+1),
                  pstate_ff_shift_in => pstate_shift(j*(C+1)+i),
                  pstate_ff_shift_out => pstate_shift(j*(C+1)+i+1),
                  reset => reset,
                  clk => clk
              );
              
              in1: if (j /= (R-1)) generate
                  plu_in(2*(j*C+i)) <= plu_out((j+1)*C+i);
              end generate;
              
              plu_in(2*(j*C+i)+1) <= plu_out(j*C+i-1);
              
          end generate even_row_odd_column;
          
          odd_row_even_column: if (((j mod 2) = 1) and ((i mod 2) = 0)) generate
              
              plu_ij: plu port map(
                  inp1 => plu_in(2*(j*C+i)),
                  inp2 => plu_in(2*(j*C+i)+1),
                  outp => plu_out(j*C + i),
                  config => config,
                  test => normal_test,
                  lut_shift_in => lut_shift(j*C+i),
                  lut_shift_out => lut_shift((j+1)*C+i),
                  mux_ctrl_shift_in => mux_ctrl_shift(j*(C+1)+i+1),
                  mux_ctrl_shift_out => mux_ctrl_shift(j*(C+1)+i),
                  pstate_ff_shift_in => pstate_shift(j*(C+1)+i+1),
                  pstate_ff_shift_out => pstate_shift(j*(C+1)+i),
                  reset => reset,
                  clk => clk
              );
              
              in1: if (i /= (C-1)) generate
                  plu_in(2*(j*C+i)) <= plu_out(j*C+i+1);
              end generate;
              
              plu_in(2*(j*C+i)+1) <= plu_out((j-1)*C+i);
              
          end generate odd_row_even_column;
          
          odd_row_odd_column: if (((j mod 2) = 1) and ((i mod 2) = 1)) generate
              
              plu_ij: plu port map(
                  inp1 => plu_in(2*(j*C+i)),
                  inp2 => plu_in(2*(j*C+i)+1),
                  outp => plu_out(j*C + i),
                  config => config,
                  test => normal_test,
                  lut_shift_in => lut_shift((j+1)*C+i),
                  lut_shift_out => lut_shift(j*C+i),
                  mux_ctrl_shift_in => mux_ctrl_shift(j*(C+1)+i+1),
                  mux_ctrl_shift_out => mux_ctrl_shift(j*(C+1)+i),
                  pstate_ff_shift_in => pstate_shift(j*(C+1)+i+1),
                  pstate_ff_shift_out => pstate_shift(j*(C+1)+i),
                  reset => reset,
                  clk => clk
              );
              
              in2: if (i /= (C-1)) generate
                  plu_in(2*(j*C+i)+1) <= plu_out(j*C+i+1);
              end generate;
              
              in1: if (j /= (R-1)) generate
                  plu_in(2*(j*C+i)) <= plu_out((j+1)*C+i);
              end generate;
              
          end generate odd_row_odd_column;
          
          input_demuxes: if (((j = 0) and ((i mod 2) = 0)) or ((j = (R-1)) and ((i mod 2) = 1))
                          or ((i = 0) and ((j mod 2) = 0)) or ((i = (C-1)) and ((j mod 2) = 1))) generate
          
              top: if ((j = 0) and ((i mod 2) = 0)) generate
                  demux_ij: demux port map(
                      a => top_in(i/2),
                      s => config_or_test,
                      b => plu_in(2*(j*C+i)+1),
                      c => lut_shift(j*C+i)
                  );
              end generate top;
              
              bottom: if ((j = (R-1)) and ((i mod 2) = 1)) generate
                  demux_ij: demux port map(
                      a => bottom_in((i-1)/2),
                      s => config_or_test,
                      b => plu_in(2*(j*C+i)),
                      c => lut_shift((j+1)*C+i)
                  );
              end generate bottom;
              
              left: if ((i = 0) and ((j mod 2) = 0)) generate
                  demux_ij: demux port map(
                      a => left_in(j/2),
                      s => config_or_test,
                      b => plu_in(2*(j*C+i)),
                      c => mux_ctrl_shift(j*(C+1)+i)
                  );
                  
                  pstate_shift(j*(C+1)+i) <= pstate_shift(j*(C+1)+i+C+1);
                  
              end generate left;
              
              right: if ((i = (C-1)) and ((j mod 2) = 1)) generate
                  demux_ij: demux port map(
                      a => right_in((j-1)/2),
                      s => config_or_test,
                      b => plu_in(2*(j*C+i)),
                      c => pstate_shift(j*(C+1)+i+1)
                  );
                  
                  mux_ctrl_shift(j*(C+1)+i+1) <= mux_ctrl_shift(j*(C+1)+i-C);
                  
              end generate right;
                    
          end generate input_demuxes;
          
          output_muxes: if (((j = 0) and ((i mod 2) = 1)) or ((j = (R-1)) and ((i mod 2) = 0))
                         or ((i = 0) and ((j mod 2) = 1)) or ((i = (C-1)) and ((j mod 2) = 0))) generate
          
              top: if ((j = 0) and ((i mod 2) = 1)) generate
                  mux_ij: mux port map(
                      a => plu_out(j*C + i),
                      b => lut_shift(j*C+i),
                      s => config_or_test,
                      c => top_out_not((i-1)/2)
                  );
                    
                  not_ij: inverter port map(
                      inp => top_out_not((i-1)/2),
                      outp => top_out((i-1)/2)
                  );
              end generate top;
              
              bottom: if ((j = (R-1)) and ((i mod 2) = 0)) generate
                  mux_ij: mux port map(
                      a => plu_out(j*C + i),
                      b => lut_shift((j+1)*C+i),
                      s => config_or_test,
                      c => bottom_out_not(i/2)
                  );
                    
                  not_ij: inverter port map(
                      inp => bottom_out_not(i/2),
                      outp => bottom_out(i/2)
                  );
              end generate bottom;
              
              left: if ((i = 0) and ((j mod 2) = 1)) generate
                  mux_ij: mux port map(
                      a => plu_out(j*C + i),
                      b => mux_ctrl_shift(j*(C+1)+i),
                      s => config_or_test,
                      c => left_out_not((j-1)/2)
                  );
                    
                  not_ij: inverter port map(
                      inp => left_out_not((j-1)/2),
                      outp => left_out((j-1)/2)
                  );
              end generate left;
              
              right: if ((i = (C-1)) and ((j mod 2) = 0)) generate
                  mux_ij: mux port map(
                      a => plu_out(j*C+i),
                      b => pstate_shift(j*(C+1)+i+1),
                      s => config_or_test,
                      c => right_out_not(j/2)
                  );
                    
                  not_ij: inverter port map(
                      inp => right_out_not(j/2),
                      outp => right_out(j/2)
                  );
              end generate right;
              
          end generate output_muxes;

        end generate gen_fpla_rows;
    end generate gen_fpla_cols;
    
end fpla_structural;

