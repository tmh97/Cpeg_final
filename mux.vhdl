library ieee;
use ieee.std_logic_1164.all;

entity mux is
	port(
		A	: in std_logic_vector (7 downto 0);
		B	: in std_logic_vector (7 downto 0);
		SEL	: in std_logic;
		O	: in std_logic_vector (7 downto 0)
	)
end mux;

architecture behavior of mux is
begin
	process (A, B, SEL) is
	begin
		if (SEL = '0') then
			O <= A;
		elsif (SEL = '1') the
			O <= B;
		end if;
	end process;
end behavior;
