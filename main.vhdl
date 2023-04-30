library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity processor is
	port(clk, reset: in std_logic);
end entity;

architecture pipelined of processor is

-- Adding all components
component instrmem is 
port(
    M_add : in std_logic_vector(15 downto 0);
    M_data : out std_logic_vector(15 downto 0));
end component;

component IFID is 
    port( Mem1_D, PC, alu1_C : in std_logic_vector(15 downto 0); 
          Mem1_D_out, PC_out, alu1_C_out : out std_logic_vector(15 downto 0); 
          disable, clk : in std_logic);
end component;

component IDRR is 
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
          disable, clk : in std_logic);
end component;

component RREX is 
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
          disable, clk : in std_logic);
end component;

component EXMA is 
    port( Mem1_D, PC, alu1_C, R0_data, RF_D1,RF_D2,SE7_alu2_C : in std_logic_vector(15 downto 0); 
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
          disable, clk : in std_logic);
end component;

component MAWB is 
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
end component;

component memsplit is
	--Splits the memory instruction into its components
	port (Mem_data: in std_logic_vector(15 downto 0);
			opcode: out std_logic_vector(3 downto 0);
			Mem_11_9: out std_logic_vector(2 downto 0);
      Mem_5_0: out std_logic_vector(5 downto 0);
      Mem_8_6: out std_logic_vector(2 downto 0);
      Mem_8_0: out std_logic_vector(8 downto 0);
      Mem_5_3: out std_logic_vector(2 downto 0);
      Mem_7_0: out std_logic_vector(7 downto 0));
end component;

component MUX_2x1_16BIT is 
  port (I0,I1: in std_logic_vector(15 downto 0) ;Sel_16bit : in std_logic; Y: out std_logic_vector(15 downto 0));
end component;

component register_file is 
-- PC is R0 so incorporating it in register file itself
-- A1,A2,A3 are reg addresses, D1,D2,D3 are reg data PC_w is write enable for PC and and RF_W is write enable for writing on reg
-- PC_write is input port for PC and PC_read is output port for PC
port(
    clock, reset, PC_w, RF_W : in std_logic;
    A1, A2, A3 : in std_logic_vector(2 downto 0);
    D3, PC_write : in std_logic_vector(15 downto 0);
    D1, D2, PC_read: out std_logic_vector(15 downto 0));
end component;

component se7 is
	--This component increases the size of a 9 bit vector to 16 bit vector, keeping the value of the vector same
	port (A: in std_logic_vector(8 downto 0);
			outp: out std_logic_vector(15 downto 0));
end component;

component se10 is
	--This component increases the size of a vector to a 16 bit vector, keeping the value of the vector same
	port (A: in std_logic_vector(5 downto 0);
			outp: out std_logic_vector(15 downto 0));
end component;

component alu1 is
	--An ALU that has 2 16 bit inputs, 2 select lines, an output X and 2 flags Carry C and Zero Z
	port (
	A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	X: out std_logic_vector(15 downto 0));
end component;

component alu2 is
	--An ALU that has 2 16 bit inputs, 2 select lines, an output X and 2 flags Carry C and Zero Z
	port (
	A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	sel: in std_logic;
	X: out std_logic_vector(15 downto 0);
	C: out std_logic;
	Z: out std_logic);
end component;

component alu3 is
	--An ALU that has 2 16 bit inputs, 2 select lines, an output X and 2 flags Carry C and Zero Z
	port (
	A: in std_logic_vector(15 downto 0);
	B: in std_logic
	X: out std_logic_vector(15 downto 0);
	C: out std_logic;
	Z: out std_logic);
end component;

component compblock is
	--This component produces complement of a 16 bit vector if the control bit is set
	port (A: in std_logic_vector(15 downto 0);
			control : in std_logic;
			outp: out std_logic_vector(15 downto 0));
end component;

component datamem is 
port(
    M_add, M_inp : in std_logic_vector(15 downto 0);
    M_data : out std_logic_vector(15 downto 0);
    clock, Mem_W : in std_logic);
end component;
 -- Initializing the required signals
begin 
 -----
 --Instruction Fetch Stage
 -----
end architecture;