library ieee;
use ieee.std_logic_1164.all;

entity extender is
	port(
		A   : in  std_logic_vector (3 downto 0);
		O   : out std_logic_vector (7 downto 0)
	);
end extender;

architecture behavior of extender is
begin
	process (A) is
	begin
		O <= "0000" & A;
	end process;
end behavior;
