Library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX_2x1_16BIT is 
  port (I0,I1: in std_logic_vector(15 downto 0) ;Sel_16bit : in std_logic; Y: out std_logic_vector(15 downto 0));
  end entity MUX_2x1_16BIT ;


architecture Struct of MUX_1X2_16BIT is

 component MUX_2x1_4BIT is 
port (I0,I1 : in std_logic_vector(3 downto 0); Sel : in std_logic ; Y : out std_logic_vector(3 downto 0));
 end component MUX_2x1_4BIT ;

  --signal y_1,y_0 : std_logic;
  
  begin 
   M1 : MUX_2X1_4BIT port map (I0=> I0(15 downto 12),I1 => I1 (15 downto 12), Sel => Sel_16bit,Y => Y(15 downto 12));
	M2 : MUX_2X1_4BIT port map (I0=> I0(11 downto 8),I1 => I1 (11 downto 9), Sel => Sel_16bit,Y => Y(11 downto 9));
	M3 : MUX_2X1_4BIT port map (I0=> I0(7  downto 4),I1 => I1 (7 downto 4), Sel => Sel_16bit,Y => Y(7 downto 4));
	M4 : MUX_2X1_4BIT port map (I0=> I0(3 downto 0),I1 => I1 (3 downto 0), Sel => Sel_16bit,Y => Y(3 downto 0));

   
 
  
end Struct;