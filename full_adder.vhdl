library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
	port(
		A 	: in std_logic;
		B 	: in std_logic;
		Carry_In 	: in std_logic;
		Sum	: out std_logic;
		Carry_Out	: out std_logic
	);

end full_adder;

architecture behavior of full_adder is

	component half_adder
		port(
			A	: in std_logic;
			B	: in std_logic;
			Sum	: out std_logic;
			Carry	: out std_logic
		);
	end component;

	signal sum : std_logic;
	signal carry_0 : std_logic;
	signal carry_1 : std_logic;

begin

	half_adder0: half_adder
		port map (
			A => A,
			B => B,
			Sum => sum,
			Carry => carry_0
		);

	half_adder1: half_adder
		port map (
			A => sum,
			B => Carry_In,
			Sum => Sum,
			Carry => carry_1
		);

	Carry_Out <= carry_0 or carry_1;

end behavior;
