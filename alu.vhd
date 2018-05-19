library ieee;
use ieee.std_logic_1164.all;

-- ALU
entity alu is 
    port(
        enable	 : in  std_logic;
        ALUOp 	 : in  std_logic_vector (2 downto 0);
        input_A     	 : in  std_logic_vector (7 downto 0);
        input_B     	 : in  std_logic_vector (7 downto 0);
        result	 : out std_logic_vector (7 downto 0) := (others => 'X');
        print 	 : out std_logic_vector (7 downto 0) := (others => 'X');
        oflow 	 : out std_logic := '0';
        uflow 	 : out std_logic := '0';
        zero  	 : out std_logic := '0'
    );
    
end alu;

architecture structural of alu is
	
	component add2
		generic (LENGTH : integer);
		port(
			c_op  	 : in  std_logic;
			i_A   	 : in  std_logic_vector (LENGTH-1 downto 0);
			i_B   	 : in  std_logic_vector (LENGTH-1 downto 0);
			o_Z   	 : out std_logic_vector (LENGTH-1 downto 0) := (others => 'X');
			o_flow	 : out std_logic
		);
	end component;
	component comparator
		generic (LENGTH : integer);
		port(
			input_A	 : in  std_logic_vector (LENGTH-1 downto 0);
			input_B	 : in  std_logic_vector (LENGTH-1 downto 0);
			output_A	 : out std_logic_vector (LENGTH-1 downto 0);
			output_Z	 : out std_logic_vector (1 downto 0)
		);
	end component;
	
	-- state types
	type STATE_TYPE is (load, add, sub, print, beq, noop);
	
	-- add/subtract signals
	signal op : std_logic := '0';
	signal addsub_result : std_logic_vector (7 downto 0) := (others => 'X');
	signal flow : std_logic := 'X';
	signal comp : std_logic_vector (1 downto 0) := "XX";
	
begin
	
	addsub: add2
		generic map (LENGTH => 8)
		port map (
			op  	 => s_op,
			A   	 => i_A,
			B   	 => i_B,
			Z   	 => s_addsub_result,
			flow	 => s_flow
		);
	beq_comparator: comparator2
		generic map (LENGTH => 8)
		port map (
			input_A	 => i_A,
			input_B	 => i_B,
			output_A => open,
			output_Z => s_comp
		);
	
	-- logic below
	process (c_enable,
	         c_ALUOp,
	         i_A,
	         i_B,
	         s_addsub_result,
	         s_comp,
	         s_flow) is
		variable state : STATE_TYPE;
	begin
		
		if c_enable = '1' then
			
			state_machine_case: case c_ALUOp(2 downto 1) is
				when "00"	=> state := load;
				when "01"	=> state := add;
				when "10"	=> state := sub;
				when "11"	=>
					special_state_case: case c_ALUOp(0) is
						when '0'	=> state := beq;
						when '1'	=> state := print;
						when others	=> state := noop;
					end case special_state_case;
				when others	=> state := noop;
			end case state_machine_case;
			
			logic_case: case state is
				when load =>
					s_op <= '0';
					-- ignore i_A
					o_result <= i_B;
					-- control signals
					o_zero <='0';
					o_oflow <= '0';
					o_uflow <= '0';
				when add =>
					s_op <= '0';
					o_result <= s_addsub_result;
					-- control signals
					o_zero <= '0';
					if s_flow = '1' then
						if i_A(7) = '0' and i_B(7) = '0' then
							o_oflow <= '1';
							o_uflow <= '0';
						elsif i_A(7) = '1' and i_B(7) = '1' then
							o_oflow <= '0';
							o_uflow <= '1';
						else 
							o_oflow <= '0';
							o_uflow <= '0';
						end if;
					else
						o_oflow <= '0';
						o_uflow <= '0';
					end if;
				when sub =>
					op <= '1';
					result <= addsub_result;
					-- control signals
					zero <= '0';
					if flow = '1' then
						if i_A(7) = '0' and i_B(7) = '1' then
							oflow <= '1';
							uflow <= '0';
						elsif i_A(7) = '1' and i_B(7) = '0' then
							oflow <= '0';
							uflow <= '1';
						else 
							oflow <= '0';
							uflow <= '0';
						end if;
					else
						oflow <= '0';
						uflow <= '0';
					end if;
				when beq =>   -- beq (or skip)
					op <= '1';
					result <= "XXXXXXXX";
					if comp = "00" then
						zero <= '1';
					else
						zero <= '0';
					end if;
					-- control signals
					oflow <= '0';
					uflow <= '0';
				when print =>   -- print
					op <= '0';
					result <= "XXXXXXXX";
					print <= i_A;
					-- ignore i_B
					-- control signals
					zero <= '0';
					oflow <= '0';
					uflow <= '0';
				when noop =>   -- noop (do nothing)
					op <= '0';
					result <= "XXXXXXXX";
					-- control signals
					zero <= '0';
					oflow <= '0';
					uflow <= '0';
			end case logic_case;
			
		end if;
	end process;
	
end structural;
