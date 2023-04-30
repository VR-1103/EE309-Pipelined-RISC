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
			for i in range(2 downto 0) loop
				---- TODO: reduce temp by 1;
			end loop;
			lmsm_out <= input>>1;
		else
			lmsm_out <= input>>1;
			lmsm_a <= --what is the null thingy;
		end if;
	end process;
end behav;
			