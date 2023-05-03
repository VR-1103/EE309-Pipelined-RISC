-- A DUT entity is used to wrap your design so that we can combine it with testbench.
-- This example shows how you can do this for the OR Gate

library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port(input_vector: in std_logic_vector(1 downto 0));
end entity;

architecture DutWrap of DUT is
   component processor is
		port(clk, reset: in std_logic);
	end component;
begin

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
   add_instance: processor 
			port map (
					-- order of inputs B A
					clk => input_vector(1),
					reset => input_vector(0));
end DutWrap;