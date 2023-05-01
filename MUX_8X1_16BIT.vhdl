Library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX_8X1_16BIT is 
  port (I7,I6,I5,I4,I3,I2,I1,I0 :in std_logic_vector( 15 downto 0);
       S: in std_logic_vector(2 downto 0);Y : out std_logic_vector(15 downto 0));
  end entity MUX_8X1_16BIT ;


architecture Struct of MUX_8X1_16BIT is

component MUX_8X1_4BIT is 
   port (I7,I6,I5,I4,I3,I2,I1,I0 : in_std_logic_vector(3 downto 0); S: in std_logic_vector(2 downto 0);Y : out std_logic_vector( 3 downto 0));
  end component MUX_8X1_4BIT ;

   
  begin 
   M1 : MUX_8X1_4BIT port map (I7=>I7(15 downto 12),I6=>I6(15 downto 12),I5=>I5(15 downto 12),I4=>I4(15 downto 12),
                               I3=>I3(15 downto 12),I2=>I2(15 downto 12),I1=>I1(15 downto 12),I0=>I0(15 downto 12), S=>S, Y=>Y(15 downto 12));
										 
   M2 : MUX_8X1_4BIT port map  (I7=>I7(11 downto 8),I6=>I6(11 downto 8),I5=>I5(11 downto 8),I4=>I4(11 downto 8),
                               I3=>I3(11 downto 8),I2=>I2(11 downto 8),I1=>I1(11 downto 8),I0=>I0(11 downto 8), S=>S, Y=>Y(11 downto 8));
										 
   M3 : MUX_8X1_4BIT port map (I7=>I7(7 downto 4),I6=>I6(7 downto 4),I5=>I5(7 downto 4),I4=>I4(7 downto 4),
                               I3=>I3(7 downto 4),I2=>I2(7 downto 4),I1=>I1(7 downto 4),I0=>I0(7 downto 4), S=>S, Y=>Y(7 downto 4));
										 
  M4 : MUX_8X1_4BIT port map (I7=>I7(3 downto 0),I6=>I6(3 downto 0),I5=>I5(3 downto 0),I4=>I4(3 downto 0),
                               I3=>I3(3 downto 0),I2=>I2(3 downto 0),I1=>I1(3 downto 0),I0=>I0(3 downto 0), S=>S, Y=>Y(3 downto 0));									 
	

   
 
  
end Struct;