library ieee;
use ieee.std_logic_1164.all;

entity compblock is
	--This component produces complement of a 16 bit vector if the control bit is set
	port (A: in std_logic_vector(15 downto 0);
			outp: out std_logic_vector(15 downto 0));
end compblock;

architecture bhv of compblock is
begin

output:process(A)
begin
	loop1: for k in 0 to 15 loop
		outp(k) <= not(A(k));
	end loop;
end process;
end architecture;