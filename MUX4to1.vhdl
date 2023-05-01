Library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUX_4_1  is
  port ( S:in_std_logic_vector(1 downto 0) ; I: in std_logic_vector(3 downto 0); Y: out std_logic);
end entity MUX_4_1;

architecture Struct of MUX_4_1 is
  signal Y1, Y0: std_logic;

component MUX_2_1  is
  port (S, I0, I1 : in std_logic; Y: out std_logic);
end component MUX_2_1;

begin
  -- component instances
	MUX2_1: MUX_2_1 port map (S => S(1), I1 => I(3), I0 => I(1), Y => Y1);
	MUX2_2: MUX_2_1 port map (S => S(1), I1 => I(2), I0 => I(0), Y => Y0);

	MUX2_3: MUX_2_1 port map (S => S(0), I1=> Y1, I0 => Y0, Y => Y);
end Struct;