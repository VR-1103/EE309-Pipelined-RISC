library ieee;
use ieee.std_logic_1164.all;

entity memsplit is
	--Splits the memory instruction into its components
	port (Mem_data: in std_logic_vector(15 downto 0);
			Mem_11_9: out std_logic_vector(2 downto 0);
      Mem_5_0: out std_logic_vector(5 downto 0);
      Mem_8_6: out std_logic_vector(2 downto 0);
      Mem_8_0: out std_logic_vector(8 downto 0);
      Mem_5_3: out std_logic_vector(2 downto 0);
      Mem_7_0: out std_logic_vector(7 downto 0));
end memsplit;

architecture bhv of memsplit is
begin

Mem_11_9 <= Mem_data(11 downto 9);
Mem_5_0 <= Mem_data(5 downto 0);
Mem_8_6 <= Mem_data(8 downto 6);
Mem_8_0 <= Mem_data(8 downto 0);
Mem_5_3 <= Mem_data(5 downto 3);
Mem_7_0 <= Mem_data(7 downto 0);

end architecture;
