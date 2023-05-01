library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity IFID is 
    port( Mem1_D, PC, alu1_C : in std_logic_vector(15 downto 0); 
          Mem1_D_out, PC_out, alu1_C_out : out std_logic_vector(15 downto 0);
			 disable_wb: out std_logic;
          disable, clk, stall : in std_logic);
end entity;

architecture simple of IFID is
    begin
        process(clk, Mem1_D, PC, alu1_C)
        begin
            if(rising_edge(clk) and stall = '0') then
                PC_out <= PC;
                Mem1_D_out <= Mem1_D;
                alu1_C_out <= alu1_C;
				else
					null;
            end if;
				if (rising_edge(clk) and disable = '1') then
					disable_wb <= disable;
				else
					disable_wb <= '0';
				end if;
        end process;
end architecture simple;

entity IDRR is 
    port( Mem1_D, PC, alu1_C : in std_logic_vector(15 downto 0); 
          opcode: in std_logic_vector(3 downto 0);
          D_11_9, D_8_6 : in std_logic_vector(3 downto 0);
          D_5_0: in std_logic_vector(5 downto 0);
          D_8_0: in std_logic_vector(8 downto 0);
          D_8_3: in std_logic_vector(5 downto 0);
          D_7_0: in std_logic_vector(7 downto 0);

          opcode_out: out std_logic_vector(3 downto 0);
          D_11_9_out, D_8_6_out : out std_logic_vector(3 downto 0);
          D_5_0_out: out std_logic_vector(5 downto 0);
          D_8_0_out: out std_logic_vector(8 downto 0);
          D_8_3_out: out std_logic_vector(5 downto 0);
          D_7_0_out: out std_logic_vector(7 downto 0);
          Mem1_D_out, PC_out, alu1_C_out : out std_logic_vector(15 downto 0);
			 disable_wb, rfa1_mux: out std_logic; 
          disable, clk, stall : in std_logic);
end entity;

architecture simple of IDRR is
    begin
        process(clk, Mem1_D, PC, alu1_C)
        begin
            if(rising_edge(clk) and stall = '0') then
                opcode_out <= opcode;
                D_11_9_out <= D_11_9;
                D_8_6_out <= D_8_6;
                D_5_0_out <= D_5_0;
                D_8_0_out <= D_8_0;
                D_8_3_out <= D_8_3;
                D_7_0_out <= D_7_0;
                PC_out <= PC;
                Mem1_D_out <= Mem1_D;
                alu1_C_out <= alu1_C;
					 if (opcode(3 downto 2)="01") then
						rfa1_mux <= '1';
					 else
						rfa1_mux <= '0';
					end if;
				else
					null;
            end if;
				if (rising_edge(clk) and disable = '1') then
					disable_wb <= disable;
				else
					disable_wb <= '0';
				end if;
        end process;
end architecture simple;

entity RREX is 
    port( Mem1_D, PC, alu1_C, R0_data, RF_D1,RF_D2 : in std_logic_vector(15 downto 0); 
          opcode: in std_logic_vector(3 downto 0);
          D_11_9, D_8_6 : in std_logic_vector(3 downto 0);
          D_5_0: in std_logic_vector(5 downto 0);
          D_8_0: in std_logic_vector(8 downto 0);
          D_8_3: in std_logic_vector(5 downto 0);
          D_7_0: in std_logic_vector(7 downto 0);

          opcode_out: out std_logic_vector(3 downto 0);
          D_11_9_out, D_8_6_out : out std_logic_vector(3 downto 0);
          D_5_0_out: out std_logic_vector(5 downto 0);
          D_8_0_out: out std_logic_vector(8 downto 0);
          D_8_3_out: out std_logic_vector(5 downto 0);
          D_7_0_out: out std_logic_vector(7 downto 0);
          Mem1_D_out, PC_out, alu1_C_out, R0_data_out, RF_D1_out, RF_D2_out : out std_logic_vector(15 downto 0);
			 disable_wb: out std_logic; 
          disable, clk,stall : in std_logic;
			 alu_select: out std_logic_vector(1 downto 0);
			 alu4a_mux_control: out std_logic
			 alu2a_pipeline_control: out std_logic;
			 alu2b_pipeline_control: out std_logic_vector(1 downto 0));
end entity;

architecture simple of RREX is
    begin
        process(clk, Mem1_D, PC, alu1_C)
        begin
            if(rising_edge(clk) and stall = '0') then
                R0_data_out <= R0_data;
                RF_D1_out <= RF_D1;
                RF_D2_out <= RF_D2;
                opcode_out <= opcode;
                D_11_9_out <= D_11_9;
                D_8_6_out <= D_8_6;
                D_5_0_out <= D_5_0;
                D_8_0_out <= D_8_0;
                D_8_3_out <= D_8_3;
                D_7_0_out <= D_7_0;
                PC_out <= PC;
                Mem1_D_out <= Mem1_D;
                alu1_C_out <= alu1_C;
					
					if (opcode(3 downto 2) = "11") then
						alu2a_pipeline_control <= '1';
					else
						alu2_a_pipeline_control <= '0';
					end if;
					
					if (opcode(3 downto 0) = "0001") then
						if (Mem1_D(2) = '0') then
							alu2b_pipeline_control <= "00";
						else
							alu2b_pipeline_control <= "01";
						end if;
					elsif (opcode(3 downto 0) = "0010") then
						if (Mem1_D(2) = '0') then
							alu2b_pipeline_control <= "00";
						else
							alu2b_pipeline_control <= "01";
						end if;
					elsif (opcode(3 downto 2) = "10") then
						alu2b_pipeline_control <= "00";
					elsif (opcode(3 downto 0) = "0000" or opcode(3 downto 0) = "0011" or opcode(3 downto 0) = "0100") then
						alu2b_pipeline_control <= "10";
					elsif (opcode(3 downto 2) = "11") then
						alu2b_pipeline_control <= "11";
					else
						null;
					end if;
					
					if (opcode(3 downto 1)="000" or opcode(3 downto 2)="01") then
						alu_select <= "00";
					elsif (opcode(3 downto 0)="001") then
						alu_select <= "01";
					elsif (opcode(3 downto 2)="10") then
						alu_select <= "11";
					else null;
					end if;
					
					if (opcode(3 downto 0)="1111") then
						alu4a_mux_control <= '1';
					else
						alu4a_mux_control <= '0';
					end if;
				
				else
					null;
            end if;
				
				if (rising_edge(clk) and disable = '1') then
					disable_wb <= disable;
				else
					disable_wb <= '0';
				end if;
        end process;
end architecture simple;

entity EXMA is 
    port( Mem1_D, PC, alu1_C, R0_data, RF_D1,RF_D2,SE7, alu2_C : in std_logic_vector(15 downto 0); 
          opcode: in std_logic_vector(3 downto 0);
          D_11_9, D_8_6 : in std_logic_vector(3 downto 0);
          D_5_0: in std_logic_vector(5 downto 0);
          D_8_0: in std_logic_vector(8 downto 0);
          D_8_3: in std_logic_vector(5 downto 0);
          D_7_0: in std_logic_vector(7 downto 0);

          opcode_out: out std_logic_vector(3 downto 0);
          D_11_9_out, D_8_6_out : out std_logic_vector(3 downto 0);
          D_5_0_out: out std_logic_vector(5 downto 0);
          D_8_0_out: out std_logic_vector(8 downto 0);
          D_8_3_out: out std_logic_vector(5 downto 0);
          D_7_0_out: out std_logic_vector(7 downto 0);
          Mem1_D_out, PC_out, alu1_C_out, R0_data_out, RF_D1_out, RF_D2_out, SE7_out, alu2_C_out : out std_logic_vector(15 downto 0); 
          disable_wb: out std_logic;
			 disable, clk : in std_logic);
end entity;

architecture simple of RREX is
    begin
        process(clk, Mem1_D, PC, alu1_C)
        begin
            if(rising_edge(clk)) then
                SE7_out <= SE7;
                alu2_C_out < alu2_C;
                R0_data_out <= R0_data;
                RF_D1_out <= RF_D1;
                RF_D2_out <= RF_D2;
                opcode_out <= opcode;
                D_11_9_out <= D_11_9;
                D_8_6_out <= D_8_6;
                D_5_0_out <= D_5_0;
                D_8_0_out <= D_8_0;
                D_8_3_out <= D_8_3;
                D_7_0_out <= D_7_0;
                PC_out <= PC;
                Mem1_D_out <= Mem1_D;
                alu1_C_out <= alu1_C;
            else
					null;
				end if;
				if (rising_edge(clk) and disable = '1') then
					disable_wb <= disable;
				else
					disable_wb <= '0';
				end if;
        end process;
end architecture simple;

entity MAWB is 
    port( Mem1_D, PC, alu1_C, R0_data, RF_D1,RF_D2, Mem2_D : in std_logic_vector(15 downto 0); 
          opcode: in std_logic_vector(3 downto 0);
          D_11_9, D_8_6 : in std_logic_vector(3 downto 0);
          D_5_0: in std_logic_vector(5 downto 0);
          D_8_0: in std_logic_vector(8 downto 0);
          D_8_3: in std_logic_vector(5 downto 0);
          D_7_0: in std_logic_vector(7 downto 0);

          opcode_out: out std_logic_vector(3 downto 0);
          D_11_9_out, D_8_6_out : out std_logic_vector(3 downto 0);
          D_5_0_out: out std_logic_vector(5 downto 0);
          D_8_0_out: out std_logic_vector(8 downto 0);
          D_8_3_out: out std_logic_vector(5 downto 0);
          D_7_0_out: out std_logic_vector(7 downto 0);
          Mem1_D_out, PC_out, alu1_C_out, R0_data_out, RF_D1_out, RF_D2_out, Mem2_D_out : out std_logic_vector(15 downto 0); 
          disable, clk : in std_logic);
end entity;

architecture simple of MAWB is
    begin
        process(clk, Mem1_D, PC, alu1_C)
        begin
            if(rising_edge(clk)) then
                Mem2_D_out <= Mem2_D;
                R0_data_out <= R0_data;
                RF_D1_out <= RF_D1;
                RF_D2_out <= RF_D2;
                opcode_out <= opcode;
                D_11_9_out <= D_11_9;
                D_8_6_out <= D_8_6;
                D_5_0_out <= D_5_0;
                D_8_0_out <= D_8_0;
                D_8_3_out <= D_8_3;
                D_7_0_out <= D_7_0;
                PC_out <= PC;
                Mem1_D_out <= Mem1_D;
                alu1_C_out <= alu1_C;
				else
					null;
            end if;
        end process;
end architecture simple;