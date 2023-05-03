Library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX_8x1 is 
  port (I: in std_logic_vector(7 downto 0); S: in std_logic_vector(2 downto 0); Y: out std_logic);
  end entity MUX_8x1 ;


architecture Struct of MUX_8X1 is

 component MUX_2_1  is
  port (S, I0, I1 : in std_logic; Y: out std_logic);
end component MUX_2_1;

component MUX_4_1  is
 port ( S:in std_logic_vector(1 downto 0) ; I: in std_logic_vector(3 downto 0); Y: out std_logic);
end component MUX_4_1;

  signal y_1,y_0 : std_logic;
  
  begin 
      M1 : MUX_4_1 port map (S(1)=>S(1), S(0)=>S(0), I(3)=>I(7), I(2)=>I(6), I(1)=>I(5), I(0)=>I(4), Y =>y_1 );
	M2 : MUX_4_1 port map (S(1)=>S(1), S(0)=>S(0), I(3)=>I(3), I(2)=>I(2), I(1)=>I(1), I(0)=>I(0), Y =>y_0 );
	M3 : MUX_2_1 port map ( S => S(2), I1=> y_1, I0 => y_0 , Y => Y);
	
	

   
 
  
end Struct;