Library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX_4X1_4BIT is 
  port (I3,I2,I1,I0:in_std_logic_vector(3 downto 0) ; S: in std_logic(1 downto 0) ; Y : out std_logic_vector(3 downto 0));
  end entity MUX_4X1_4BIT ;


architecture Struct of MUX_4X1_4BIT is

component MUX_4_1  is
  port ( S:in_std_logic_vector(1 downto 0) ; I: in std_logic_vector(3 downto 0); Y: out std_logic);
end component MUX_4_1;

   begin 
      M1 : MUX_4_1 port map (S(1)=>S(1),S(0)=>S(0),I(3)=>I3(3),I(2)=>I3(2) ,I(1)=>I3(1),  I(0)=>I3(0),Y =>Y(3));
	M2 : MUX_4_1 port map (S(1)=>S(1),S(0)=>S(0),I(3)=>I2(3),I(2)=>I2(2) ,I(1)=>I2(1),  I(0)=>I2(0),Y =>Y(2));
	M3 : MUX_4_1 port map (S(1)=>S(1),S(0)=>S(0),I(3)=>I1(3),I(2)=>I1(2) ,I(1)=>I1(1),  I(0)=>I1(0),Y =>Y(1));
	M4 : MUX_4_1 port map (S(1)=>S(1),S(0)=>S(0),I(3)=>I0(3),I(2)=>I0(2) ,I(1)=>I0(1),  I(0)=>I0(0),Y =>Y(0));
	

   
 
  
end Struct;