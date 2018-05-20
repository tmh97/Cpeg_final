library ieee;
use ieee.std_logic_1164.all;

entity exectute_to_writeback is
	port(
		CLK	: in std_logic;
		enable	: in std_logic;
		reset	: in std_logic;
		flush	: in std_logic;

		branch_in	: in std_logic;
		regWrite_in	: in std_logic;
		
		pc_in	: in std_logic_vector(7 downto 0);
		wd_in	: in std_logic_vector(7 downto 0);
		wr_in	: in std_logic_vector(1 downto 0);
		skip_in : in std_logic;

		branch_out	: out std_logic;
		regWrite_out	: out std_logic;
		
		pc_out	: out std_logic_vector(7 downto 0) := "00000000";
		wd_out	: out std_logic_vector(7 downto 0) := "XXXXXXXX";
		wr_out	: out std_logic_vector(1 downto 0) := "XX";
		skip_out : out std_logic := '0'
		);
end execute_to_writeback;

architecture behavior of exectute_to_writeback is
begin
	process(CLK, enable, reset, flush) is
		begin
			if reset = '1' or flush = '1' then
				branch <= '0';
				regWrite <= '0';
				pc_out <= "00000000";
				wd_out <= "XXXXXXXX";
				wr_reg <= "XX";
				skip_out <= '0';
			elsif rising_edge(CLK) and enable = '1' then
				branch_out <= branch_in;
				regWrite_out <= regWrite_in;
				pc_out <= pc_in;
				wd_out <= wd_in;
				wr_out <= wr_in;
				skip_out <= skip_in;
			end if;
		end process;
end behavior;
		
