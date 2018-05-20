library ieee;
use ieee.std_logic_1164.all;

entity half_adder is
	port(
		A	: in std_logic;
		B	: in std_logic;
		Sum	: out std_logic;
		Carry	: out std_logic
	);

end half_adder;

architecture behavior of half_adder is
	
begin
		S <= A xor B; -- adds the two inputs
		Carry <= A and B; -- finds the carry
	
end behavior;


