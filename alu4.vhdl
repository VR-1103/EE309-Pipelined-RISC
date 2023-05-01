library ieee;
use ieee.std_logic_1164.all;

entity alu4 is
	port(A, B: in std_logic_vector(15 downto 0);
			X: out std_logic_vector(15 downto 0));
end entity;

architecture Struct of alu4 is
	
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
		return carry(15) & sum;
	end add;

begin

process(A,B)

variable temp: std_logic_vector(15 downto 0);
variable temp1: std_logic_vector(16 downto 0);

begin
	L1: for i in 0 to 15 loop
		if i=0 then
			temp(i) := '0';
		else
			temp(i) := B(i-1);
		end if;
	end loop;
	temp1 := add(A,temp);
	X <= temp1(15 downto 0);
end process;

end architecture;
	