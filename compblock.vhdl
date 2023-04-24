library ieee;
use ieee.std_logic_1164.all;

entity compblock is
	--This component produces complement of a 16 bit vector if the control bit is set
	port (A: in std_logic_vector(15 downto 0);
			control : in std_logic;
			outp: out std_logic_vector(15 downto 0));
end compblock;

architecture bhv of compblock is
begin

output:process(control,A)
begin
	if (control='0') then
		outp <= A;
	elsif (control='1') then
		loop1 : for k in 0 to 15 loop
			outp(k) <= not(A(k));
		end loop loop1;
	else null;
	end if;
	
end process;
end architecture;