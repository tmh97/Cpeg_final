library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
	port(
		Enable	: in std_logic;

		Instruction	: in std_logic_vector (2 downto 0);

		RegDst		: out std_logic;	
		Branch		: out std_logic := '0';
		ALUOp		: out std_logic_vector := (2 downto 0);
		ALUSrc		: out std_logic;		
		RegWrite	: out std_logic := '0'
	);
end control_unit;

architecture behavior of control_unit is

signal load, add, sub, print, beq : std_logic;

begin
	process (Enable, Instruction) is
	begin
		if Enable = '1' then
			if Instruction(2 downto 1) = "00" then
				load <= '1';
				add, sub, print, beq <= '0';
			elsif Instruction(2 downto 1) = "01" then
				add <= '1';
				load, sub, print, beq <= '0';
			elsif Instruction(2 downto 1) = "10" then
				sub <= '1';
				add, load, print, beq <= '0';
			elsif Instruction(2 downto 1) = "11" then
				if Instruction(0) = '0' then
					beq <= '1';
					add, sub, print, load <= '0';
				elsif Instruction(0) = '1' then
					print <= '1';
					add, sub, load, beq <= '0';
				end if;
			end if;
		end if;
	
		if (load = '1') then
			regDst <= '0';
			Branch <= '0';
			ALUOp <= '000';
			ALUSrc <= '1';
			RegWrite <= '1';
		elsif (add = '1') then 
			regDst <= '1';
			Branch <= '0';
			ALUOp <= '010';
			ALUSrc <= '0';
			RegWrite <= '1';
		elsif (sub = '1') then
			regDst <= '1';
			Branch <= '0';
			ALUOp <= '100';
			ALUSrc <= '0';
			RegWrite <= '1';
		elsif (beq = '1') then
			regDst <= 'X';
			Branch <= '1';
			ALUOp <= '110';
			ALUSrc <= '0';
			RegWrite <= '0';
		elsif (print = '1') then
			regDst <= 'X';
			Branch <= '0';
			ALUOp <= '111';
			ALUSrc <= 'X';
			RegWrite <= '0';
		end if;
	end process;
end behavior;
