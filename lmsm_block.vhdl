library ieee;
use ieee.std_logic_1164.all;

entity lmsm_block is
	port(
	input: in std_logic_vector(15 downto 0);
	lmsm_a: out std_logic_vector(2 downto 0);
	lmsm_out: out std_logic_vector(15 downto 0));
end entity;

architecture behav of lmsm_block is
	begin
	lmsm_process: process(control,input)
	variable temp: std_logic_vector(2 downto 0) := "111"
	begin
		if input(0) = '1' then
			lmsm_a <= temp;
			if (temp = "111") then
				temp := "110";
			elsif (temp = "110") then
				temp := "101";
			elsif (temp = "101") then
				temp := "100";
			elsif (temp = "100") then
				temp := "011";
			elsif (temp = "011") then
				temp := "010";
			elsif (temp = "010") then
				temp := "001";
			elsif (temp = "001") then
				temp := "000";
			else null;
			end if;
			lmsm_out <= input>>1;
		else
			lmsm_out <= input>>1;
			lmsm_a <= --what is the null thingy;
		end if;
	end process;
end behav;
			