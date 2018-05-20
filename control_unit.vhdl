library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
	port(
		enable	: in std_logic;

		instruction	: in std_logic_vector (2 downto 0);

		regDst		: out std_logic := 'X';	
		branch		: out std_logic := '0';
		ALUOp		: out std_logic_vector := (2 downto 0) := "XXX";
		ALUSrc		: out std_logic  'X';		
		regWrite	: out std_logic := '0'
	);
end control_unit;

architecture behavior of control_unit is

signal load, add, sub, print, beq : std_logic;

begin
	process (enable, instruction) is
	begin
		if enable = '1' then
			if instruction(2 downto 1) = "00" then
				load <= '1';
				add, sub, print, beq <= '0';
			elsif instruction(2 downto 1) = "01" then
				add <= '1';
				load, sub, print, beq <= '0';
			elsif instruction(2 downto 1) = "10" then
				sub <= '1';
				add, load, print, beq <= '0';
			elsif instruction(2 downto 1) = "11" then
				if instruction(0) = '0' then
					beq <= '1';
					add, sub, print, load <= '0';
				elsif instruction(0) = '1' then
					print <= '1';
					add, sub, load, beq <= '0';
				end if;
			end if;
		end if;
	
		if (load = '1') then
			regDst <= '0';
			branch <= '0';
			ALUOp <= '000';
			ALUSrc <= '1';
			regWrite <= '1';
		elsif (add = '1') then 
			regDst <= '1';
			branch <= '0';
			ALUOp <= '010';
			ALUSrc <= '0';
			regWrite <= '1';
		elsif (sub = '1') then
			regDst <= '1';
			branch <= '0';
			ALUOp <= '100';
			ALUSrc <= '0';
			regWrite <= '1';
		elsif (beq = '1') then
			regDst <= 'X';
			branch <= '1';
			ALUOp <= '110';
			ALUSrc <= '0';
			regWrite <= '0';
		elsif (print = '1') then
			regDst <= 'X';
			branch <= '0';
			ALUOp <= '111';
			ALUSrc <= 'X';
			regWrite <= '0';
		end if;
	end process;
end behavior;
