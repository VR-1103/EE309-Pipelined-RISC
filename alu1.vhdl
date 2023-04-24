library ieee;
use ieee.std_logic_1164.all;

entity alu1 is
	--An ALU that has 2 16 bit inputs, 2 select lines, an output X and 2 flags Carry C and Zero Z
	port (
	A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	X: out std_logic_vector(15 downto 0));
end alu1;

architecture pc of alu1 is
	
	function add(A: in std_logic_vector(15 downto 0);
						B: in std_logic_vector(15 downto 0))
		return std_logic_vector is
			variable sum : std_logic_vector(15 downto 0) := (others => '0');
			variable carry : std_logic_vector(15 downto 0) := (others => '0');
		begin
			L1: for i in 0 to 15 loop
				if i = 0 then
					sum(i) := A(i) xor B(i) xor '0';
					carry(i) := A(i) and B(i);
				else 
					sum(i) := A(i) xor B(i) xor carry(i-1);
					carry(i) := (A(i) and B(i)) or (carry(i-1) and (A(i) xor B(i)));
				end if;
			end loop L1;
		return sum;
	end add;
	
	begin
	alu_proc: process(A,B)
	begin
		X <= add(A,B);
	end process;

end pc;