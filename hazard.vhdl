library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

--hazard entity for dependency in arithmetic and logical instructions
entity hazard_EX is
	port( RREX_opcode, EXMA_opcode, MAWB_opcode: in std_logic_vector(3 downto 0); ex_flag :in std_logic_vector(1 downto 0),
		  RREX_11_9, RREX_8_6, RREX_11_9, EXMA_11_9, MAWB_11_9, MAWB_8_6, MAWB_5_3: in std_logic_vector(2 downto 0);
		stall_IFID, stall_IDRR, disable_IFID, disable_IDRR, disable_RREX: out std_logic
        alu2a_mux, alu2b_mux : out std_logic_vector(2 downto 0));  -- disable means we don't write anything in pipelined register in WB stage
		                                                           -- stall means for that clock cycle we have halted the operation this is implementated 
end entity;

architecture hazardous of hazard_EX is
signal jalr_jri_jal , beq,ble,blt : std_logic := '0';
begin
alu2a_haz_mux <= "01" when(RREX_11_9 = EXMA_5_3 and (EXMA_opcode = "0001" or EXMA_opcode = "0010"));
alu2a_haz_mux <= "10" when(RREX_11_9 = MAWB_5_3 and (MAWB_opcode = "0001" or MAWB_opcode = "0010"));
alu2b_haz_mux <= "01" when(RREX_8_6 = EXMA_5_3 and (EXMA_opcode = "0001" or EXMA_opcode = "0010"));
alu2b_haz_mux <= "10" when(RREX_8_6 = MAWB_5_3 and (MAWB_opcode = "0001" or MAWB_opcode = "0010"));

jalr_jri_jal <= '1' when(RREX_opcode = "1100" or "1101" or "1111") else '0'; -- basically when there is all unconditional jump statements jal,jlr,jri then disable if_id,id_rr,rr_ex in nxt clk cycle
beq <= '1' when(RREX_opcode = "1000"  and (ex_flag = '01')) else '0';
blt <= '1' when(RREX_opcode = "1000"  and (ex_flag = '10')) else '0';
ble <= '1' when(RREX_opcode = "1001"  and (ex_flag = '10' or '11')) else '0'; 

when(rising_edge(clk))
 disable_IFID <= jalr_jri_jal or beq or ble or blt ;
 disable_IDRR <= jalr_jri_jal or beq or ble or blt ;
 disable_RREX <= jalr_jri_jal or beq or ble or blt ;

 -- need to make rf_w, mem2_w, flag_w =0

end architecture;
