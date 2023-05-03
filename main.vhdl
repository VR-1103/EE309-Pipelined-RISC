library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library std;
use std.standard.all;

library work;
use work.Gates.all;

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
			 disable_wb: out std_logic;
          disable, clk, stall : in std_logic);
end component;

component IDRR is 
    port( Mem1_D, PC, alu1_C : in std_logic_vector(15 downto 0); 
          opcode: in std_logic_vector(3 downto 0);
          D_11_9, D_8_6 : in std_logic_vector(2 downto 0);
          D_5_0: in std_logic_vector(5 downto 0);
          D_8_0: in std_logic_vector(8 downto 0);
          D_5_3: in std_logic_vector(2 downto 0);
          D_7_0: in std_logic_vector(7 downto 0);

          opcode_out: out std_logic_vector(3 downto 0);
          D_11_9_out, D_8_6_out : out std_logic_vector(2 downto 0);
          D_5_0_out: out std_logic_vector(5 downto 0);
          D_8_0_out: out std_logic_vector(8 downto 0);
          D_5_3_out: out std_logic_vector(2 downto 0);
          D_7_0_out: out std_logic_vector(7 downto 0);
          Mem1_D_out, PC_out, alu1_C_out : out std_logic_vector(15 downto 0);
			 disable_wb, rfa1_mux: out std_logic; 
          disable, clk, stall : in std_logic);
end component;

component RREX is 
    port( Mem1_D, PC, alu1_C, RF_D1,RF_D2 : in std_logic_vector(15 downto 0); 
          opcode: in std_logic_vector(3 downto 0);
          D_11_9, D_8_6 : in std_logic_vector(2 downto 0);
          D_5_0: in std_logic_vector(5 downto 0);
          D_8_0: in std_logic_vector(8 downto 0);
          D_5_3: in std_logic_vector(2 downto 0);
          D_7_0: in std_logic_vector(7 downto 0);

          opcode_out: out std_logic_vector(3 downto 0);
          D_11_9_out, D_8_6_out : out std_logic_vector(2 downto 0);
          D_5_0_out: out std_logic_vector(5 downto 0);
          D_8_0_out: out std_logic_vector(8 downto 0);
          D_5_3_out: out std_logic_vector(2 downto 0);
          D_7_0_out: out std_logic_vector(7 downto 0);
          Mem1_D_out, PC_out, alu1_C_out, RF_D1_out, RF_D2_out : out std_logic_vector(15 downto 0);
			 disable_wb: out std_logic; 
          disable, clk,stall : in std_logic;
			 alu_select: out std_logic_vector(1 downto 0);
			 alu4a_mux_control: out std_logic;
			 alu2a_pipeline_control: out std_logic;
			 alu2b_pipeline_control: out std_logic_vector(1 downto 0);
       c_prev,z_prev: in std_logic);
end component;

component EXMA is 
    port( Mem1_D, PC, alu1_C, RF_D1,RF_D2,SE7, alu2_X, alu3_X : in std_logic_vector(15 downto 0); 
          opcode: in std_logic_vector(3 downto 0);
          D_11_9, D_8_6 : in std_logic_vector(2 downto 0);
          D_5_0: in std_logic_vector(5 downto 0);
          D_8_0: in std_logic_vector(8 downto 0);
          D_5_3: in std_logic_vector(2 downto 0);
          D_7_0: in std_logic_vector(7 downto 0);

          opcode_out: out std_logic_vector(3 downto 0);
          D_11_9_out, D_8_6_out : out std_logic_vector(2 downto 0);
          D_5_0_out: out std_logic_vector(5 downto 0);
          D_8_0_out: out std_logic_vector(8 downto 0);
          D_5_3_out: out std_logic_vector(2 downto 0);
          D_7_0_out: out std_logic_vector(7 downto 0);
          Mem1_D_out, PC_out, alu1_C_out, RF_D1_out, RF_D2_out, SE7_out, alu2_X_out, alu3_X_out : out std_logic_vector(15 downto 0); 
          disable_wb,M_write : out std_logic;
			 flags_out: out std_logic_vector(1 downto 0);
			 disable, clk, alu2_C, alu2_Z: in std_logic);
end component;

component MAWB is 
    port( Mem1_D, PC, alu1_C, RF_D1,RF_D2, Mem2_D, SE7, alu2_X, alu3_X : in std_logic_vector(15 downto 0); 
          opcode: in std_logic_vector(3 downto 0);
          D_11_9, D_8_6 : in std_logic_vector(2 downto 0);
          D_5_0: in std_logic_vector(5 downto 0);
          D_8_0: in std_logic_vector(8 downto 0);
          D_5_3: in std_logic_vector(2 downto 0);
          D_7_0: in std_logic_vector(7 downto 0);

          opcode_out: out std_logic_vector(3 downto 0);
          D_11_9_out, D_8_6_out : out std_logic_vector(2 downto 0);
          D_5_0_out: out std_logic_vector(5 downto 0);
          D_8_0_out: out std_logic_vector(8 downto 0);
          D_5_3_out: out std_logic_vector(2 downto 0);
          D_7_0_out: out std_logic_vector(7 downto 0);
          Mem1_D_out, PC_out, alu1_C_out, RF_D1_out, RF_D2_out, Mem2_D_out, SE7_out, alu2_X_out, alu3_X_out : out std_logic_vector(15 downto 0); 
          disable, clk: in std_logic;
			 flags: in std_logic_vector(1 downto 0);
			 rf_w_enable,disable_out: out std_logic;
			 flags_out,rfd3_mux,rfa3_mux: out std_logic_vector(1 downto 0));
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

component MUX_4x1_16BIT is 
  port (I3,I2,I1,I0 : in std_logic_vector(15 downto 0); S: in std_logic_vector(1 downto 0); Y : out std_logic_vector(15 downto 0));
end component;

component MUX_8X1_16BIT is 
  port (I7,I6,I5,I4,I3,I2,I1,I0 :in std_logic_vector( 15 downto 0);
       S: in std_logic_vector(2 downto 0);Y : out std_logic_vector(15 downto 0));
end component;

component register_file is 
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
	disable: in std_logic;
	sel: in std_logic_vector(1 downto 0);
	X: out std_logic_vector(15 downto 0);
	C: out std_logic;
	Z: out std_logic);
end component;

component alu3 is
	--An ALU that has 2 16 bit inputs, 2 select lines, an output X and 2 flags Carry C and Zero Z
	port (
	A: in std_logic_vector(15 downto 0);
	B: in std_logic;
	X: out std_logic_vector(15 downto 0);
	C: out std_logic;
	Z: out std_logic);
end component;

component alu4 is
	port(A, B: in std_logic_vector(15 downto 0);
			X: out std_logic_vector(15 downto 0));
end component;

component compblock is
	--This component produces complement of a 16 bit vector if the control bit is set
	port (A: in std_logic_vector(15 downto 0);
			outp: out std_logic_vector(15 downto 0));
end component;

component datamem is 
port(
    M_add, M_inp : in std_logic_vector(15 downto 0);
    M_data : out std_logic_vector(15 downto 0);
    clock, Mem_W : in std_logic);
end component;

component hazard_EX is
	port( RREX_opcode, EXMA_opcode, MAWB_opcode: in std_logic_vector(3 downto 0); 
		  RREX_11_9, RREX_8_6,RREX_5_3, EXMA_11_9,EXMA_8_6,EXMA_5_3, MAWB_11_9, MAWB_8_6, MAWB_5_3: in std_logic_vector(2 downto 0);
          RREX_2_0, EXMA_2_0, MAWB_2_0 : in std_logic_vector(2 downto 0);
          RREX_state_disable, EXMA_state_disable, MAWB_state_disable,alu2_c,alu2_z: in std_logic;
          disable_IFID, disable_IDRR, disable_RREX, disable_EXMA: out std_logic;
          alu2a_mux, alu2b_mux, PC_mux : out std_logic_vector(2 downto 0));  -- disable means we don't write anything in pipelined register in WB stage
end component;
 
 component MUX_2X1_3BIT is 
	port (I0,I1 : in std_logic_vector(2 downto 0); Sel : in std_logic ; Y : out std_logic_vector(2 downto 0));
 end component;
 
 component MUX_4X1_3BIT is 
  port (I3,I2,I1,I0:in std_logic_vector(2 downto 0) ; S: in std_logic_vector(1 downto 0) ; Y : out std_logic_vector(2 downto 0));
 end component;
 
 -- Initializing the required signals
 
 signal pc_in,pc_out,pc_out_ifid,pc_out_idrr,pc_out_rrex,pc_out_exma,pc_out_mawb,mem1_out,mem1_out_ifid,
			mem1_out_idrr,mem1_out_rrex,mem1_out_exma,mem1_out_mawb,alu1x,alu1x_ifid,alu1x_idrr,alu1x_rrex,alu1x_exma,
			alu1x_mawb,decoder_in,rfd1,rfd2,rfd3_in,se10_out,se7_out,rfd1_rrex,rfd2_rrex,rfd1_exma,rfd2_exma,rfd1_mawb,rfd2_mawb,
      cb_out,alu2a_in,alu2b_in,alu2x,alu2x_exma,alu2x_mawb,alu2a_pipeline,alu2b_pipeline,alu3x,alu3x_exma,alu3x_mawb,alu4a_in,alu4x,se7_exma,
      se7_mawb,mem_data,mem_data_wb: std_logic_vector(15 downto 0);
 
 signal rf_write,disable_ifid,disable_idrr,disable_rrex,disable_exma,disable_mawb,disable_idrr_forward,
			disable_rrex_forward,disable_exma_forward,disable_idrr_hazard,disable_rrex_hazard,
			disable_exma_hazard,disabled,stall_ifid,stall_idrr,stall_rrex,
			rfa1_mux_control,alu4a_mux_control,alu2a_control,c_flag,z_flag,mem_enable: std_logic := '0';
 
 signal pc_mux_control: std_logic_vector(2 downto 0) := "000";
 
 signal alu2_select,flags_mawb,flags_wb,rfd3_mux_control,rfa3_mux_control,alu2b_control: std_logic_vector(1 downto 0) := "00";
 
 signal decoder_opcode,opcode_idrr,opcode_rrex,opcode_exma,opcode_mawb: std_logic_vector(3 downto 0);
 
 signal decoder_11_9,idrr_11_9,decoder_8_6,idrr_8_6,decoder_5_3,idrr_5_3,rrex_11_9,rrex_8_6,
			rrex_5_3,exma_11_9,exma_8_6,exma_5_3,mawb_11_9,mawb_8_6,
      mawb_5_3,rfa1_in,rfa3_in,alu2a_hazard_control,alu2b_hazard_control: std_logic_vector(2 downto 0) := "000";
 
 signal decoder_5_0,idrr_5_0,rrex_5_0,exma_5_0,mawb_5_0: std_logic_vector(5 downto 0);
 
 signal decoder_8_0,idrr_8_0,rrex_8_0,exma_8_0,mawb_8_0: std_logic_vector(8 downto 0);
 
 signal decoder_7_0,idrr_7_0,rrex_7_0,exma_7_0,mawb_7_0: std_logic_vector(7 downto 0);

begin 
 
 -----
 --Instruction Fetch Stage
 -----
 
 rf: register_file port map(clk,reset,'1',rf_write,rfa1_in,idrr_8_6,rfa3_in,rfd3_in,pc_in,rfd1,rfd2,pc_out);
 
 mem1: instrmem port map(pc_out,mem1_out);
 
 alu_1: alu1 port map(pc_out,"0000000000000001",alu1x);
 
 pcmux: MUX_8x1_16BIT port map("0000000000000000","0000000000000000",alu3x,mem_data,se7_out,alu4x,alu2x,
											alu1x,pc_mux_control,pc_in);
 
 ifid_pipeline_register: IFID port map(mem1_out,pc_out,alu1x,mem1_out_ifid,pc_out_ifid,alu1x_ifid,disable_idrr_forward,disable_ifid,clk,stall_ifid);
 
 disable_idrr <=  '1' when (disable_idrr_forward = '1' or disable_idrr_hazard = '1') else '0';
 -----
 --Instruction Decode Stage
 -----
 
 decoder: memsplit port map(mem1_out_ifid,decoder_opcode,decoder_11_9,decoder_5_0,decoder_8_6,decoder_8_0,decoder_5_3,decoder_7_0);
 
 idrr_pipeline_register: IDRR port map(mem1_out_ifid,pc_out_ifid,alu1x_ifid,decoder_opcode,decoder_11_9,
												decoder_8_6,decoder_5_0,decoder_8_0,decoder_5_3,decoder_7_0,opcode_idrr,idrr_11_9,
												idrr_8_6,idrr_5_0,idrr_8_0,idrr_5_3,idrr_7_0,mem1_out_idrr,pc_out_idrr,alu1x_idrr,
												disable_rrex_forward,rfa1_mux_control,disable_idrr,clk,stall_idrr);
 
 disable_rrex <= '1' when (disable_rrex_forward = '1' or disable_rrex_hazard = '1') else '0';
 
 -----
 --Register Read Stage
 -----
 
 rfa1_mux: MUX_2x1_3BIT port map(idrr_11_9,idrr_8_6,rfa1_mux_control,rfa1_in);
 
 rrex_pipeline_register: RREX port map(mem1_out_idrr,pc_out_idrr,alu1x_idrr,rfd1,rfd2,opcode_idrr,idrr_11_9,
												idrr_8_6,idrr_5_0,idrr_8_0,idrr_5_3,idrr_7_0,opcode_rrex,rrex_11_9,rrex_8_6,
												rrex_5_0,rrex_8_0,rrex_5_3,rrex_7_0,mem1_out_rrex,pc_out_rrex,alu1x_rrex,
												rfd1_rrex,rfd2_rrex,disable_exma_forward,disable_rrex,clk,stall_rrex,alu2_select,
												alu4a_mux_control,alu2a_control,alu2b_control,c_flag,z_flag);
 
 disable_exma <= '1' when (disable_exma_forward = '1' or disable_exma_hazard = '1') else '0';
 
 -----
 --Execute Stage
 -----
 
 se_10: se10 port map(rrex_5_0,se10_out);
 
 se_7: se7 port map(rrex_8_0,se7_out);
 
 alu2a_pipeline_mux: MUX_2x1_16BIT port map(rfd1_rrex,pc_out_rrex,alu2a_control,alu2a_pipeline);
 
 alu2a_hazard_mux: MUX_8x1_16BIT port map(alu3x_mawb,alu3x_exma,mem_data,se7_mawb,se7_exma,alu2x_mawb,alu2x_exma,
														alu2a_pipeline,alu2a_hazard_control,alu2a_in);
 
 alu2b_pipeline_mux: MUX_4x1_16BIT port map("0000000000000010",se10_out,cb_out,rfd2_rrex,alu2b_control,alu2b_pipeline);
 
 alu2b_hazard_mux: MUX_8x1_16BIT port map(alu3x_mawb,alu3x_exma,mem_data,se7_mawb,se7_exma,alu2x_mawb,alu2x_exma,
														alu2b_pipeline,alu2b_hazard_control,alu2b_in);
 
 complement_block: compblock port map(rfd2_rrex,cb_out);
 
 alu_2: alu2 port map(alu2a_in,alu2b_in,disable_exma,alu2_select,alu2x,c_flag,z_flag);
 
 alu_3: alu3 port map(alu2x,c_flag,alu3x,c_flag,z_flag);
 
 alu4a_mux: MUX_2x1_16BIT port map(pc_out_rrex,rfd1_rrex,alu4a_mux_control,alu4a_in);
 
 alu_4: alu4 port map(alu4a_in,se7_out,alu4x);
 
 exma_pipeline_register: EXMA port map(mem1_out_rrex,pc_out_rrex,alu1x_rrex,rfd1_rrex,rfd2_rrex,se7_out,alu2x,alu3x,opcode_rrex,
                                        rrex_11_9,rrex_8_6,rrex_5_0,rrex_8_0,rrex_5_3,rrex_7_0,opcode_exma,exma_11_9,exma_8_6,
                                        exma_5_0,exma_8_0,exma_5_3,exma_7_0,mem1_out_exma,pc_out_exma,alu1x_exma,rfd1_exma,rfd2_exma,
                                        se7_exma,alu2x_exma,alu3x_exma,disable_mawb,mem_enable,flags_mawb,disable_exma,clk,c_flag,z_flag);
  
 hazard_block: hazard_EX port map(opcode_rrex,opcode_exma,opcode_mawb,rrex_11_9,rrex_8_6,rrex_5_3,exma_11_9,exma_8_6,exma_5_3,mawb_11_9,
												mawb_8_6,mawb_5_3,mem1_out_rrex(2 downto 0),mem1_out_exma(2 downto 0),
												mem1_out_mawb(2 downto 0),disable_exma,disable_mawb,disabled,c_flag,z_flag,disable_ifid,disable_idrr_hazard,
												disable_rrex_hazard,disable_exma_hazard,alu2a_hazard_control,
												alu2b_hazard_control,pc_mux_control);
  
  -----
  --Memory Access Stage
  -----
  
  mem2: datamem port map(alu2x_exma,rfd2_exma,mem_data,clk,mem_enable);
  
  mawb_pipeline_register: MAWB port map(mem1_out_exma,pc_out_exma,alu1x_exma,rfd1_exma,rfd2_exma,mem_data,se7_exma,alu2x_exma,
                                        alu3x_exma,opcode_exma,exma_11_9,exma_8_6,exma_5_0,exma_8_0,exma_5_3,exma_7_0,opcode_mawb,
                                        mawb_11_9,mawb_8_6,mawb_5_0,mawb_8_0,mawb_5_3,mawb_7_0,mem1_out_mawb,pc_out_mawb,alu1x_mawb,
                                        rfd1_mawb,rfd2_mawb,mem_data_wb,se7_mawb,alu2x_mawb,alu3x_mawb,disable_mawb,clk,flags_mawb,rf_write,
                                        disabled,flags_wb,rfd3_mux_control,rfa3_mux_control);
  
  ------
  --Write Back Stage
  -----
  
  rfd3_mux: MUX_4x1_16BIT port map(alu3x_mawb,mem_data_wb,se7_mawb,alu2x_mawb,rfd3_mux_control,rfd3_in);
  
  rfa3_mux: MUX_4X1_3BIT port map("000",mawb_11_9,mawb_8_6,mawb_5_3,rfa3_mux_control,rfa3_in);
 
 
end architecture;