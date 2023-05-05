library ieee;
use ieee.std_logic_1164.all;
library std;
use std.standard.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity alu2 is
	--An ALU that has 2 16 bit inputs, 2 select lines, an output X and 2 flags Carry C and Zero Z
	port (
	A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	disable: in std_logic;
	sel: in std_logic_vector(1 downto 0);
	X: out std_logic_vector(15 downto 0);
	C: out std_logic;
	Z: out std_logic);
end alu2;

architecture execute of alu2 is

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
	
--	function sub(A: in std_logic_vector(15 downto 0);
--						B: in std_logic_vector(15 downto 0))
--		return std_logic_vector is
--			variable sum : std_logic_vector(15 downto 0) := (others => '0');
--			variable carry : std_logic_vector(15 downto 0) := (others => '0');
--		begin
--			L3: for i in 0 to 15 loop
--				if i = 0 then
--					sum(i) := (A(i) xor B(i)) xor '0';
--					carry(i) := ('0' and not(A(i) xor B(i)) ) or not(A(i) and B(i));
--				else
--                    sum(i) := (A(i) xor B(i)) xor carry(i-1);
--					carry(i) := (carry(i-1) and not(A(i) xor B(i)) ) or not(A(i) and B(i));
--				end if;
--			end loop L3;
--		return carry(15) & sum;
--	end sub;
	
	signal temp: std_logic_vector(16 downto 0) := "00000000000000000";
	signal tempz: std_logic;
	
	begin
	
	Z <= tempz;
	alu_proc: process(A,B,sel)

	begin
		if (disable = '0') then
			if sel="00" then
				temp <= add(A,B);
				X <= temp(15 downto 0);
				C <= temp(16);
				if temp(15 downto 0)="0000000000000000" then
					tempZ<='1';
				else 
					tempZ<='0';
				end if;
			elsif sel="01" then
				X<= A nand B;
				C<='0';
				if (A nand B)="0000000000000000" then
					tempZ<='1';
				else 
					tempZ<='0';
				end if;
			elsif sel="11" then
--				compb <= not B;
--				temp1 <= add(compb,one_trial);
--				twoscomp <= temp1(15 downto 0);
--				temp <= sub(A,B);
--				X <= temp(15 downto 0);
--				C <=  not temp(16);
--				if temp(15 downto 0)="0000000000000000" then
--					Z<='1';
--				else 
--					Z<='0';
--				end if;
				if (to_integer(unsigned(A)) = to_integer(unsigned(B))) then
					C<='0';
					tempZ<='1';
				elsif (to_integer(unsigned(A)) < to_integer(unsigned(B))) then
					C<='1';
					tempZ<='0';
				else
					C<='0';
					tempZ<='0';
				end if;
			else null;
			end if;
		else null;
		end if;
	end process;

end execute;