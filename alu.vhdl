library ieee;
use ieee.std_logic_1164.all;

entity alu is 
    port(
        enable	 : in  std_logic;
        ALUOp 	 : in  std_logic_vector (2 downto 0);
        A     	 : in  std_logic_vector (7 downto 0);
        B     	 : in  std_logic_vector (7 downto 0);
        result	 : out std_logic_vector (7 downto 0) := "XXXXXXXX";
        print_output 	 : out std_logic_vector (7 downto 0) := "XXXXXXXX");
        overflow 	 : out std_logic := '0';
        underflow 	 : out std_logic := '0';
        skip  	 : out std_logic := '0'
    );
    
end alu;

architecture behavior of alu is
	
	component add
		port(
			sub  	 : in  std_logic;
			A   	 : in  std_logic_vector (LENGTH-1 downto 0);
			B   	 : in  std_logic_vector (LENGTH-1 downto 0);
			Sum   	 : out std_logic_vector (LENGTH-1 downto 0) := "XXXXXXXX";
			overflow : out std_logic
		);
	end component;
	component comparator
		port(
			A_in	 : in  std_logic_vector (7 downto 0);
			B	 : in  std_logic_vector (7 downto 0);
			A_out	 : out std_logic_vector (7 downto 0);
			O	 : out std_logic_vector (1 downto 0)
		);
	end component;
	
	
	-- add/subtract signals
	signal load, add, sub, print, beq	: std_logic;
	signal add_or_sub	: std_logic := '0';
	signal adder_result	: std_logic_vector (7 downto 0) := "XXXXXXXX";
	signal flow	: std_logic := 'X';
	signal beq_result	: std_logic_vector (1 downto 0) := "XX";
	
begin
	
	adder: add
		port map (
			sub 	 => add_or_sub,
			A   	 => A,
			B   	 => B,
			Sum   	 => adder_result,
			overflow => flow
		);
	beq_component: comparator
		port map (
			A_in	 => A,
			B	 => B,
			A_out => open,
			O => beq_result
		);
	
	-- logic below
	process (enable, ALUOp, A, B, result, adder_result, beq_result, flow) is
	begin
		
		if enable = '1' then
			
			if ALUOp(2 downto 1) = "00" is
				load <= '1';
				add, sub, print, beq <= '0';
			elsif ALUOp(2 downto 1) = "01" is
				add <= '1';
				load, sub, print, beq <= '0';
			elsif ALUOp(2 downto 1) = "10" is
				sub <= '1';
				add, load, print, beq <= '0';
			elsif ALUOp(2 downto 1) = "11" is
				if ALUOp(0) = '0' then
					beq <= '1';
					add, sub, load, print <= '0';
				elsif ALUOp(0) = '1' then
					print <= '1';
					add, sub, load, beq <= '0';
				end if;
			end if;

			if load = '1' then
				add_or_sub <= '0';
				result <= B;
				overflow <= '0';
				underflow <= '0';
				skip <= '0'; 
			elsif add = '1' then
				add_or_sub <= '0';
				result <= adder_result;
				skip <= '0'; 
				if flow = 1 then
					if A(7) = '0' and B(7) = '0' then
						overflow <= '1';
						underflow <= '0';
					elsif A(7) = '0' and B(7) = '1' then
						overflow <= '0';
						underflow <= '1';
					end if;
				else
					overflow <= '0';
					underflow <= '0';
				end if;
			elsif sub = '1' then
				add_or_sub <= '1';
				result <= adder_result;
				skip <= '0'; 
				if flow = 1 then
					if A(7) = '0' and B(7) = '1' then
						overflow <= '1';
						underflow <= '0';
					elsif A(7) = '1' and B(7) = '0' then
						overflow <= '0';
						underflow <= '1';
					end if;
				else
					overflow <= '0';
					underflow <= '0';
				end if;
			elsif beq = '1' then
				add_or_sub <= '0';
				result <= "XXXXXXXX";
				if beq_result = "00" then
					skip <= '1';
				else
					skip <= '0';
				end if;
				overflow <= '0';
				underflow <= '0';
			elsif print = '1' then
				add_or_sub <= '0';
				result <= "XXXXXXXX";
				print_output <= A;
				skip <= '0';
				overflow <= '0';
				underflow <= '0';
			end if;
		end if;
	end process;	
end behavior;
