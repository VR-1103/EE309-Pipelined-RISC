library ieee;
use ieee.std_logic_1164.all;
library std;
use std.standard.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity lmsm_block is
	port (Mem1_D: in std_logic_vector(15 downto 0);
			prev_imm: in std_logic_vector(5 downto 0);
			was_in_process: in std_Logic;
			Mem1_D_out: out std_logic_vector(15 downto 0);
			Mem1_D_send_to_IFID: out std_logic_vector(15 downto 0);
			in_process,disable_cuz_of_lmsm: out std_logic);
end entity;

architecture haha of lmsm_block is
signal address: std_logic_vector(2 downto 0);
signal point,imm_val: integer := 0;
begin
imm_val <= to_integer(unsigned(prev_imm));
process(Mem1_D)
variable temp: std_logic_vector(7 downto 0);
begin	
if (was_in_process /= '1') then
	if (Mem1_D(15 downto 13) /= "011") then
		Mem1_D_out <= Mem1_D;
		in_process <= '0';
		disable_cuz_of_lmsm <= '0';
	else
		if(Mem1_D(7 downto 0) = "00000000") then
			disable_cuz_of_lmsm <= '1';
			Mem1_D_out <= Mem1_D;
			in_process <= '0';
		else
			in_process <= '1';
			Mem1_D_out(15 downto 13) <= "010";
			Mem1_D_out(12) <= Mem1_D(12);
			Mem1_D_out(5 downto 0) <= "000000";
			Mem1_D_out(8 downto 6) <= Mem1_D(11 downto 9);
			for i in 0 to 7 loop
				if (Mem1_D(i) = '1') then
					Mem1_D_out(11 downto 9) <= std_logic_vector(to_unsigned(7-i, Mem1_D_out(11 downto 9)'length));
					point <= i;
					temp := Mem1_D(7 downto 0);
					temp(i) := '0';
					Mem1_D_send_to_IFID(7 downto 0) <= temp;
					exit;
				else null;
				end if;
			end loop;
			Mem1_D_send_to_IFID(15 downto 8) <= Mem1_D(15 downto 8);
		end if;
	end if;
else
		if(Mem1_D(7 downto 0) = "00000000") then
			disable_cuz_of_lmsm <= '1';
			Mem1_D_out <= Mem1_D;
			in_process <= '0';
		else
			in_process <= '1';
			Mem1_D_out(15 downto 13) <= "010";
			Mem1_D_out(12) <= Mem1_D(12);
			Mem1_D_out(5 downto 0) <= std_logic_vector(to_unsigned(imm_val+1,Mem1_D_out(5 downto 0)'length));
			Mem1_D_out(8 downto 6) <= Mem1_D(11 downto 9);
			for i in 0 to 7 loop
				if (Mem1_D(i) = '1') then
					Mem1_D_out(11 downto 9) <= std_logic_vector(to_unsigned(7-i, Mem1_D_out(11 downto 9)'length));
					point <= i;
					temp := Mem1_D(7 downto 0);
					temp(i) := '0';
					Mem1_D_send_to_IFID(7 downto 0) <= temp;
					exit;
				else null;
				end if;
			end loop;
			Mem1_D_send_to_IFID(15 downto 8) <= Mem1_D(15 downto 8);
		end if;
end if;
end process;

end architecture;