library ieee;
use ieee.std_logic_1164.all;

entity decode_to_execute is
	port (
		CLK	: in std_logic;
		enable	: in std_logic;
		reset	: in std_logic;
		flush	: in std_logic;
		
		regDst_in	: in std_logic;
		branch_in	: in std_logic;
		ALUOp_in	: in std_logic_vector(2 downto 0);
		ALUSrc_in	: in std_logic;
		regWrite_in	: in std_logic;

		pc_in	: in std_logic_vector(7 downto 0);
		rd1_in	: in std_logic_vector(7 downto 0);
		rd2_in	: in std_logic_vector(7 downto 0);
		rs_in	: in std_logic_vector(1 downto 0);
		rd_in	: in std_logic_vector(1 downto 0);
		
		regDst_out	: out std_logic := 'X';
		branch_out	: out std_logic := '0';
		ALUOp_out	: out std_logic_vector(2 downto 0) := "XXXX";
		ALUSrc_out	: out std_logic := 'X';
		regWrite_out	: out std_logic := '0';
		
		pc_out	: out std_logic_vector(7 downto 0) := "XXXXXXXX";
		rd1_out	: out std_logic_vector(7 downto 0) := "XXXXXXXX";
		rd2_out	: out std_logic_vector(7 downto 0) := "XXXXXXXX";
		rs_out	: out std_logic_vector(1 downto 0) := "XXX";
		rd_out	: out std_logic_vector(1 downto 0) := "XXX"
	);
end decode_to_execute;

architecture behavior of decode_to_execute is
begin
	process(CLK, enable, reset, flush) is
	begin
		if reset = '1' or flush = '1' then
			regDst_out    <= 'X';
			branch_out   <= '0';
			ALUOp_out     <= "XXX";
			ALUSrc_out    <= 'X';
			regWrite_out  <= '0';	
			pc_out	<= "00000000";
			rd1_out	<= "XXXXXXXX";
			rd2_out <= "XXXXXXXX";
			rs_out <= "XX";
			rd_out <= "XX";		
		elsif enable = '1' and rising_edge(CLK) then
			regDst_out    <= regDst_in;
			branch_out   <= branch_in;
			ALUOp_out     <= ALUOp_in;
			ALUSrc_out    <= ALUSrc_in;
			regWrite_out  <= regWrite_in;
			pc_out	<= pc_in;
			rd1_out	<= rd1_in;
			rd2_out <=  rd2_in;
			rs_out <= rs_in;
			rd_out <= rd_in;
			
		end if;
	end process;
end behavior;
