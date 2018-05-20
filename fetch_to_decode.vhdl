library ieee;
use ieee.std_logic_1164.all;

entity fetch_to_decode is
	port (
		CLK	: in std_logic;
		enable	: in std_logic;
		reset	: in std_logic;
		flush	: in std_logic;

		pc_in	: in std_logic_vector(7 downto 0);
		instruction	: in std_logic_vector(7 downto 0);

		pc_out	: in std_logic_vector (7 downto 0) := "XXXXXXXX";
		output	: in std_logic_vector(7 downto 0) := "XXXXXXXX"
		);

architecture behavior of fetch_to_decode is
		process(CLK, enable, reset, flush) is
		begin
			if reset = '1' or flush = '1' then
				pc_out <= "00000000";
				output <= "XXXXXXXX";
			elsif enable = '1' and rising_edge(CLK) then
				pc_out <= pc_in;
				output <= instruction;
			end if;
		end process;
end behavior;
