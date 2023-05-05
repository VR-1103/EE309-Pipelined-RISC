library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all; 	 
use ieee.std_logic_unsigned.all;

entity instrmem is 
port(
    M_add : in std_logic_vector(15 downto 0);
    M_data : out std_logic_vector(15 downto 0));
end entity instrmem;

architecture behav of instrmem is

-- we take 40 memory locations for convenience, from 39 to 0
type array_of_vectors is array (39 downto 0) of std_logic_vector(15 downto 0);
signal memory_storage : array_of_vectors := 
(0 => "1000001010000010",
1 => "0100100110000001",
2 => "0001001010011000",
3 => "0001101100011001",
4 => "0010001010011000",
5 => "0010001110100001",
others => "0000000000000000");

begin
-- memory is asynchronous since there is only read function for this mem. 
   M_data <= memory_storage(to_integer(unsigned(M_add))) ;
	
end architecture behav;
