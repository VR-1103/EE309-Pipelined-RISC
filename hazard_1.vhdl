library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

--hazard entity for dependency in arithmetic and logical instructions
entity hazard_EX is
	port( RREX_opcode, EXMA_opcode, MAWB_opcode: in std_logic_vector(3 downto 0); 
		  RREX_11_9, RREX_8_6,RREX_5_3, EXMA_11_9,EXMA_8_6,EXMA_5_3, MAWB_11_9, MAWB_8_6, MAWB_5_3: in std_logic_vector(2 downto 0);
          RREX_2_0, EXMA_2_0, MAWB_2_0 : in std_logic_vector(2 downto 0);
          RREX_state_disable, EXMA_state_disable, MAWB_state_disable,alu2_c,alu2_z: in std_logic;
          disable_IFID, disable_IDRR, disable_RREX, disable_EXMA: out std_logic;
          alu2a_mux, alu2b_mux, PC_mux : out std_logic_vector(2 downto 0));  -- disable means we don't write anything in pipelined register in WB stage
end entity;

architecture hazardous of hazard_EX is
signal jalr_jri_jal , beq,ble,blt, add_nand_load_op :  std_logic := '0';
signal alu2_flags: std_logic_vector(1 downto 0);
signal alu2a_mux_temp,alu2b_mux_temp,pc_mux_temp: std_logic_vector(2 downto 0);
begin
alu2_flags(1) <= alu2_c;
alu2_flags(0) <= alu2_z;
add_nand_load_op <= '1' when(
    ((EXMA_opcode = "0001" or EXMA_opcode = "0010") and EXMA_state_disable = '0') or
    ((MAWB_opcode = "0001" or MAWB_opcode = "0010") and MAWB_state_disable = '0') or
    (EXMA_opcode = "0000") or (MAWB_opcode = "0000") or 
    (EXMA_opcode = "0011" or EXMA_opcode = "0100") or
    (MAWB_opcode = "0011" or MAWB_opcode = "0100")
) else '0';
--PC_mux (8x1 16 bit) if S= 010 => ALU4 , 001 =>ALU2 , 000 =>ALU1 011 => SE7 100 => Mem2D
pc_mux_temp <=   "000" when(RREX_state_disable = '1')  else
            "001" when(((RREX_5_3 = "000" and (RREX_opcode = "0001" or RREX_opcode = "0010") and not(RREX_2_0 = "011" or RREX_2_0 = "111") ) or --all conditional A/L
                        (RREX_opcode = "0000" and RREX_8_6 ="000" )) and add_nand_load_op = '1') else
            "010" when((RREX_opcode = "1100" or RREX_opcode = "1101" or RREX_opcode = "1111") or (RREX_opcode = "1000"  and (alu2_flags = "01")) or      --all branch +jump
                       (RREX_opcode = "1000"  and (alu2_flags = "10")) or (RREX_opcode = "1001"  and (alu2_flags = "10" or alu2_flags = "11"))) else
            "011" when (RREX_11_9 = "000" and RREX_opcode = "0011" and add_nand_load_op = '1') else   --LLI
            "100" when (EXMA_11_9 = "000" and  EXMA_opcode = "0100" and add_nand_load_op = '1') else   --LW 
            "101" when (RREX_5_3 = "000" and (RREX_opcode = "0001" or RREX_opcode = "0010") and (RREX_2_0 = "011" or RREX_2_0 = "111"))
    else    "000";

PC_mux <= pc_mux_temp;
-- alu2_EXMA 001
alu2a_mux_temp <= "001" when(((RREX_11_9 = EXMA_5_3 and (EXMA_opcode = "0001" or EXMA_opcode = "0010") and not(EXMA_2_0 = "011" or EXMA_2_0 = "111")) 
                            or ((RREX_11_9 = EXMA_8_6) and EXMA_opcode = "0000")) and add_nand_load_op = '1') else
                 "010" when(((RREX_11_9 = MAWB_5_3 and (MAWB_opcode = "0001" or MAWB_opcode = "0010") and not(MAWB_2_0 = "011" or EXMA_2_0 ="111")) 
                            or ((RREX_11_9 = MAWB_8_6) and MAWB_opcode = "0000"))  and add_nand_load_op = '1') else
                 "011" when(RREX_11_9 = EXMA_11_9 and EXMA_opcode = "0011" and add_nand_load_op = '1') else
                 "100" when(RREX_11_9 = MAWB_11_9 and MAWB_opcode = "0011" and add_nand_load_op = '1') else
                 "101" when(RREX_8_6 = MAWB_11_9 and MAWB_opcode = "0100" and add_nand_load_op = '1') else
                 "110" when((RREX_11_9 = EXMA_5_3 and (EXMA_opcode = "0001" or EXMA_opcode = "0010") and (EXMA_2_0 = "011" or EXMA_2_0 ="111")) 
                            and add_nand_load_op = '1') else
                 "111" when((RREX_11_9 = MAWB_5_3 and (MAWB_opcode = "0001" or MAWB_opcode = "0010") and (MAWB_2_0 = "011" or MAWB_2_0 = "111")) 
                            and add_nand_load_op = '1') else
                 "000";
alu2b_mux_temp <= "001" when(((RREX_8_6 = EXMA_5_3 and (EXMA_opcode = "0001" or EXMA_opcode = "0010") and not(EXMA_2_0 = "011" or EXMA_2_0 = "111")) or ((RREX_11_9 = EXMA_8_6) and EXMA_opcode = "0000")) and add_nand_load_op = '1') else
                 "010" when(((RREX_8_6 = MAWB_5_3 and (MAWB_opcode = "0001" or MAWB_opcode = "0010") and not(MAWB_2_0 = "011" or MAWB_2_0 = "111")) or ((RREX_11_9 = MAWB_8_6) and MAWB_opcode = "0000"))  and add_nand_load_op = '1') else
                 "011" when(RREX_8_6 = EXMA_11_9 and EXMA_opcode = "0011" and add_nand_load_op = '1') else
                 "100" when(RREX_8_6 = MAWB_11_9 and MAWB_opcode = "0011" and add_nand_load_op = '1') else
                 "101" when(RREX_8_6 = MAWB_11_9 and MAWB_opcode = "0100" and add_nand_load_op = '1') else
                 "110" when((RREX_8_6 = EXMA_5_3 and (EXMA_opcode = "0001" or EXMA_opcode = "0010") and (EXMA_2_0 = "011" or EXMA_2_0 = "111")) 
                        and add_nand_load_op = '1') else
                 "111" when((RREX_8_6 = MAWB_5_3 and (MAWB_opcode = "0001" or MAWB_opcode = "0010") and (MAWB_2_0 = "011" or MAWB_2_0 = "111")) 
                        and add_nand_load_op = '1') else
                 "000";

alu2a_mux <= alu2a_mux_temp;
alu2b_mux <= alu2b_mux_temp;
					  
jalr_jri_jal <= '1' when((RREX_opcode = "1100" or RREX_opcode = "1101" or RREX_opcode = "1111") and RREX_state_disable = '0') else '0'; -- basically when there is all unconditional jump statements jal,jlr,jri then disable if_id,id_rr,rr_ex in nxt clk cycle
beq <= '1' when(RREX_opcode = "1000"  and (alu2_flags = "01") and (RREX_state_disable = '0')) else '0';
blt <= '1' when(RREX_opcode = "1000"  and (alu2_flags = "10") and (RREX_state_disable = '0')) else '0';
ble <= '1' when(RREX_opcode = "1001"  and (alu2_flags = "10" or alu2_flags = "11") and (RREX_state_disable = '0')) else '0';  -- correct vedika's alu

disable_IFID <= '1'  when(jalr_jri_jal='1' or beq='1' or ble='1' or blt='1' or (pc_mux_temp = "001" or pc_mux_temp = "010" or pc_mux_temp = "011" or pc_mux_temp = "100" or pc_mux_temp = "101"));
disable_IDRR <= '1' when (jalr_jri_jal='1' or beq='1' or ble='1' or blt='1' or (PC_mux_temp = "001" or PC_mux_temp = "010" or PC_mux_temp = "011" or PC_mux_temp = "100" or pc_mux_temp ="101"));
disable_RREX <= '1' when (jalr_jri_jal = '1' or beq = '1' or ble = '1' or blt = '1' or (PC_mux_temp = "001" or PC_mux_temp = "010" or PC_mux_temp = "011" or PC_mux_temp = "100" or PC_mux_temp ="101"));
disable_EXMA <= '1' when (PC_mux_temp = "100");
 -- need to make rf_w, mem2_w, flag_w =0
end architecture;
