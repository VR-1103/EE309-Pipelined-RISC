Library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX_8X1_4BIT is 
  port (I7,I6,I5,I4,I3,I2,I1,I0 : in_std_logic_vector(3 downto 0); S: in std_logic_vector(2 downto 0);Y : out std_logic_vector( 3 downto 0));
  end entity MUX_8X1_4BIT ;


architecture Struct of MUX_8X1_4BIT is

 component  MUX_8X1 is 
 port (I: in_std_logic_vector(7 downto 0),S: in std_logic_vector(2 downto 0); Y_out : out std_logic);
  end component  MUX_8X1 ;



  --signal y_31,y_30,y_21,y_20,y_11,y_10,y_01,y_00 : std_logic;
  
  begin 
      M1 :  MUX_8X1 port map (I(7)=>I7(3),I(6)=>I6(3),I(5)=>I5(3),I(4)=>I4(3),I(3)=>I3(3),I(2)=>I2(3),I(1)=>I1(3),I(0)=>I0(3),S(2)=>S(2),S(1)=>S(1),S(0)=>S(0),Y=>Y(3));
	M2 :  MUX_8X1 port map (I(7)=>I7(2),I(6)=>I6(2),I(5)=>I5(2),I(4)=>I4(2),I(3)=>I3(2),I(2)=>I2(2),I(1)=>I1(2),I(0)=>I0(2),S(2)=>S(2),S(1)=>S(1),S(0)=>S(0),Y=>Y(2));
	M3 :  MUX_8X1 port map (I(7)=>I7(1),I(6)=>I6(1),I(5)=>I5(1),I(4)=>I4(1),I(3)=>I3(1),I(2)=>I2(1),I(1)=>I1(1),I(0)=>I0(1),S(2)=>S(2),S(1)=>S(1),S(0)=>S(0),Y=>Y(1));
	M4 :  MUX_8X1 port map (I(7)=>I7(0),I(6)=>I6(0),I(5)=>I5(0),I(4)=>I4(0),I(3)=>I3(0),I(2)=>I2(0),I(1)=>I1(0),I(0)=>I0(0),S(2)=>S(2),S(1)=>S(1),S(0)=>S(0),Y=>Y(0));
	

   
end Struct;