library ieee;
use ieee.std_logic_1164.all;

entity tb_Df_f is
end entity tb_Df_f;

architecture tb_behav of tb_Df_f is
    component Df_f
        port(
            CLK :in std_logic;      
            CE :in std_logic;   
            RESET :in std_logic;  
            D :in  std_logic;
            Q : out std_logic
          );
    end component;
    
    signal  t_CLK, t_CE, t_Res, t_D : std_logic;
    
begin
      U1 :  Df_f port map(t_CLK, t_CE, t_Res, t_D);
        
      test_process  : process
      begin
          t_CLK<='0';
	        t_CE<='0';
	        t_Res<='1';
	        t_D<='1';
          wait for 5 ns;
          
          t_CLK <='1';
          t_CE <='0';
          t_Res <='1';
          t_D <='0';
          wait for 5 ns; 
          
          t_CLK <='1';
          t_CE <='1';
          t_Res <='0';
          t_D <='1';
          wait for 5 ns;  
          
          t_CLK <='0';
          t_CE <='0';
          t_Res <='0';
          t_D <='1';
          wait for 5 ns;
         
          t_CLK <='0';
          t_CE <='1';
          t_Res <='0';
          t_D <='1';
          wait for 5 ns;

          t_CLK <='1';
          t_CE <='1';
          t_Res <='0';
          t_D <='1';
          wait for 5 ns;

          wait;          
    end process;        
end tb_behav;

