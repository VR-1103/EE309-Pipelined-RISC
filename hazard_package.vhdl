library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

--hazard entity to check LHI, LW with destination other than PC
entity hazard_RR is
	port(IDRR_opcode, RREX_opcode, EXMA_opcode, MAWB_opcode: in std_logic_vector(3 downto 0);
		  IDRR_11_9, IDRR_8_6, RREX_11_9, EXMA_11_9, MAWB_11_9: in std_logic_vector(2 downto 0);
		  stall_IFID, stall_IDRR, disable_RREX: out std_logic);
end entity;

architecture hazardous of hazard_RR is
	signal LHI_LW, rrex, exma, mawb, rrex_checked, exma_checked, mawb_checked: std_logic := '0';
begin
rrex <= '1' when((RREX_opcode = "0011" and IDRR_11_9 = RREX_11_9) or (RREX_opcode = "0100" and IDRR_11_9 = RREX_11_9) or 
						(RREX_opcode = "0011" and IDRR_8_6 = RREX_11_9) or (RREX_opcode = "0100" and IDRR_8_6 = RREX_11_9)) else '0';

rrex_checked <= '1' when (rrex = '1' and RREX_11_9 != "000") else '0';

exma <= '1' when((EXMA_opcode = "0011" and IDRR_11_9 = EXMA_11_9) or (EXMA_opcode = "0100" and IDRR_11_9 = EXMA_11_9) or 
						(EXMA_opcode = "0011" and IDRR_8_6 = EXMA_11_9) or (EXMA_opcode = "0100" and IDRR_8_6 = EXMA_11_9)) else '0';

exma_checked <= '1' when (exma = '1' and EXMA_11_9 != "000") else '0';

mawb <= '1' when((MAWB_opcode = "0011" and IDRR_11_9 = MAWB_11_9) or (MAWB_opcode = "0100" and IDRR_11_9 = MAWB_11_9) or 
						(MAWB_opcode = "0011" and IDRR_8_6 = MAWB_11_9) or (MAWB_opcode = "0100" and IDRR_8_6 = MAWB_11_9)) else '0';

mawb_checked <= '1' when (mawb = '1' and MAWB_11_9 != "000") else '0';

LHI_LW <= '1' when(rrex_checked = '1' or exma_checked = '1' or mawb_checked = '1') else '0';
stall_IFID <= LHI_LW;
stall_IDRR <= LHI_LW;
disable_RREX <= LHI_LW;

end architecture;