library ieee;
use ieee.std_logic_1164.all;
	
entity add is
	port (
		sub	: in std_logic;
		A 	: in std_logic_vector (7 downto 0);
		B	: in std_logic_vector (7 downto 0);
		Sum	: out std_logic_vector (7 downto 0) <= "XXXXXXXX";
		overflow	: out std_logic
	);

end add;

architecture behavior of add is

	component full_adder
		port(
			A	: in std_logic;
			B	: in std_logic;
			Carry_In	: in std_logic;
			Sum	: out std_logic;
			Carry_Out	: out std_logic
		);
	end component;

	signal sum_full_adder : std_logic_vector (7 downto 0) := "XXXXXXXX";
	signal carry_out : std_logic_vector (7 downto 0) := "XXXXXXXX";

begin

	overflow <= carry_out(7) xor carry_out(6);

	a_loop : for i in 0 to 7 generate

		sum_full_adder(i) <= B(i) xor sub;
 
		first_full_adder: if i = 0 generate
			full_adder0: full_adder
				port_map(
					A => A(i),
					B => sum_full_adder(i),
					Carry_In => sub,
					Sum => Sum(i),
					Carry_Out => carry_out(i)
				);
		end generate first_full_adder;
		rest_full_adder: if i > 0 generate
			full_adder_rest: full_adder
				port_map(
					A => A(i),
					B => sum_full_adder(i),
					Carry_In => carry_out(i-1);
					Sum => Sum(i);
					Carry_Out => carry_out(i)
				);
		end generate rest_full_adder;
	end generate a_loop;
end behavior;















					
					
