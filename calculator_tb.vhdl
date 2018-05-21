library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator_tb is
end calculator_tb;

architecture behavior of calculator_tb is
	component calculator is
		port(
			CLK	: in std_logic;
			reset	: in std_logic;
			enable	: in std_logic;
			instruction_number	: in std_logic_vector(7 downto 0);
			instruction	: in std_logic_vector(7 downto 0);
			pc	: out std_logic_vector(7 downto 0);
			print	: out std_logic_vector(7 downto 0)
		);
	end component;
	
	type instructions is array (30 downto 0) of STD_LOGIC_VECTOR (7 downto 0) ;
	signal instruction_memory : instructions := (
			0  => "00001000", "
			1  => "00001000",
			2  => "00001000",
			3  => "11000001",
			4  => "00010100", 
			5  => "11010001", 
			6  => "00100010", 
			7  => "11100001",  
			8  => "00110001", 
			9  => "11110001", 
			10 => "11000001",
			11 => "11010001",
			12 => "11100001",
			13 => "11110001",
			14 => "11000001",
			15 => "01101011", 
			16 => "11110001", 
			17 => "11000010", 
			18 => "11000001", 
			19 => "11010001",  
			20 => "11100001",  
			21 => "11000000", 
			22 => "11000001", 
			23 => "11010001",
			24 => "11000001", 
			25 => "10011000", 
			26 => "11000001", 
			others => "11010001"
	

	signal clk_signal             	 : std_logic := '0';
	signal end_sim      	 : std_logic := '0';
	signal reset_signal          	 : std_logic := '0';
	signal enable_signal         	 : std_logic := '0';
	signal num_instructions	 : std_logic_vector (7 downto 0) := "00011110";
	signal instruction_signal     	 : std_logic_vector (7 downto 0) := x"00";
	signal pc_signal            	 : std_logic_vector (7 downto 0) := x"00";
	signal print_signal           	 : std_logic_vector (7 downto 0) := "XXXXXXXX";
	
	constant clock_period : time := 10 ns;
			
begin
	calculator0: calculator
		port map (
			CLK               	 => clk_signal,
			reset			 => reset_signal,
			enable          	 => enable_signal,
			instruction_number	 => num_instructions,
			instruction     	 => instruction_signal,
			pc              	 => pc_signal,
			print_out           	 => print
		);
	
	process
	begin
		if not end_sim = '1' then
			clk_signal <= '0';
			wait for clock_period/2;
			clk_signal <= '1';
			wait for clock_period/2;
		else
			wait;
		end if;
	end process;
	
	process (print_signal, clk_signal) is
	variable ival : integer;
	begin
		if enable_signal = '1' and rising_edge(clk_signal)  then
			ival :=to_integer(signed(print_signal));
			report "                 PRINT: "&integer'image(ival) severity note;
		end if;
	end process;
	
	process (enable_signal, pc_signal) is
	begin
		if enable_signal = '1' then
			instruction <= instruction_memory(to_integer(unsigned(pc_signal)));
		end if;
	end process;
	
	process
	begin
		wait for 100 ns;
		wait for clock_period*10;
		
		-- setup
		reset_signal <= '1';
		wait for clock_period;
		reset_signal <= '0';
		wait for clock_period;
		enable_signal <= '1';
		
		report "PC------INSTRUCTION" severity note;
		
		for i in 0 to to_integer(unsigned(num_instructions)) loop
			wait for clock_period;
		end loop;
		
		wait for clock_period;
		enable_signal <= '0';
		
		wait for clock_period;
		
		end_sim <= '1';
		report "finished" severity note;
		wait;
	end process;	
end behavior;
