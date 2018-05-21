library ieee;
use ieee.std_logic_1164.all;
	
entity add2bit is
	port (
		sub	: in std_logic;
		A 	: in std_logic_vector (1 downto 0);
		B	: in std_logic_vector (1 downto 0);
		Sum	: out std_logic_vector (1 downto 0) <= "XX";
		overflow	: out std_logic
	);

end add2bit;

architecture behavior of add2bit is

	component full_adder
		port(
			A	: in std_logic;
			B	: in std_logic;
			Carry_In	: in std_logic;
			Sum	: out std_logic;
			Carry_Out	: out std_logic
		);
	end component;

	signal sum_full_adder : std_logic_vector (1 downto 0) := "XX";
	signal carry_out : std_logic_vector (1 downto 0) := "XX";

begin

	overflow <= carry_out(1) xor carry_out(0);

		sum_full_adder(0) <= B(0) xor sub;
		sum_full_adder(1) <= B(1) xor sub;
 
		full_adder0: full_adder
			port_map(
				A => A(0),
				B => sum_full_adder(0),
				Carry_In => sub,
				Sum => Sum(0),
				Carry_Out => carry_out(0)
				);
		full_adder1: full_adder
			port_map(
				A => A(1),
				B => sum_full_adder(1),
				Carry_In => carry_out(1);
				Sum => Sum(1);
				Carry_Out => carry_out(1)
			);
end behavior;

