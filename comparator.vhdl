library ieee;
use ieee.std_logic_1164.all;

entity comparator is
	port(
		A_in	 : in  std_logic_vector (7 downto 0);
		B	 : in  std_logic_vector (7 downto 0);
		A_out	 : out std_logic_vector (7 downto 0);
		O	 : out std_logic_vector (1 downto 0)
	);
end comparator;

architecture behavior of comparator is

signal	comparing : std_logic_vector (7 downto 0);

	function compare(A_in, B : std_logic_vector) return boolean is
	begin
		comparing <= A_in xor B;
		if(comparing /= "00000000") then
			return false;
		else
			return true;
		end if;
	end function;

begin
	process (A_in, B)_in is
	begin
		if compare(A_in, B) then
			if A_in = B then
				O <= "00";
			elsif A_in < B then
				O <= "10";
			elsif A_in > B then
				O <= "01";
			else
				O <= "XX";
			end if;
		else
			O <= "XX";
		end if;
		A_out <= A_in;
	end process;S	
end behavior;
