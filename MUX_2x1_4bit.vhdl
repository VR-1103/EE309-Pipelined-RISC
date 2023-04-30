Library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX_2X1_4BIT is 
  port (I0,I1 : in std_logic_vector(3 downto 0); Sel : in std_logic ; Y : out std_logic_vector(3 downto 0));
  end entity MUX_2X1_4BIT ;


architecture Struct of MUX_2X1_4BIT is

 component MUX_2_1  is
  port (S, I0, I1 : in std_logic; Y: out std_logic);
end component MUX_2_1;

  --signal y_1,y_0 : std_logic;
  
  begin 
   M1 : MUX_2_1 port map ( S => Sel, I0=> I0(3), I1 => I1(3), Y => Y(3));
	M2 : MUX_2_1 port map ( S => Sel, I0=> I0(2), I1 => I1(2),  Y => Y(2));
	M3 : MUX_2_1 port map ( S => Sel, I0=> I0(1), I1 => I1(1) , Y => Y(1));
	M4 : MUX_2_1 port map ( S => Sel, I0=> I0(0), I1 => I1(0), Y => Y(0));
	

   
 
  
end Struct;