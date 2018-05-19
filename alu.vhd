library ieee;
use ieee.std_logic_1164.all;

-- ALU
entity alu is 
    port(
        enable	 : in  std_logic;
        ALUOp 	 : in  std_logic_vector (2 downto 0);
        A     	 : in  std_logic_vector (7 downto 0);
        B     	 : in  std_logic_vector (7 downto 0);
        result	 : out std_logic_vector (7 downto 0) := (others => 'X');
        print 	 : out std_logic_vector (7 downto 0) := (others => 'X');
        oflow 	 : out std_logic := '0';
        uflow 	 : out std_logic := '0';
        zero  	 : out std_logic := '0'
    );
    
end alu;

architecture structural of alu is
	
	component add2
		port(
			sub  	 : in  std_logic;
			A   	 : in  std_logic_vector (LENGTH-1 downto 0);
			B   	 : in  std_logic_vector (LENGTH-1 downto 0);
			Sum   	 : out std_logic_vector (LENGTH-1 downto 0) := (others => 'X');
			overflow : out std_logic
		);
	end component;
	component comparator2
		generic (LENGTH : integer);
		port(
			input_A	 : in  std_logic_vector (LENGTH-1 downto 0);
			input_B	 : in  std_logic_vector (LENGTH-1 downto 0);
			output_A : out std_logic_vector (LENGTH-1 downto 0);
			output_Z : out std_logic_vector (1 downto 0)
		);
	end component;
	
	-- state types
	type STATE_TYPE is (load, add, sub, print, beq, noop);
	
	-- add/subtract signals
	signal s_op : std_logic := '0';
	signal s_addsub_result : std_logic_vector (7 downto 0) := (others => 'X');
	signal s_flow : std_logic := 'X';
	signal s_comp : std_logic_vector (1 downto 0) := "XX";
	
begin
	
	addsub: add
		generic map (LENGTH => 8)
		port map (
			sub 	 => s_op,
			A   	 => A,
			B   	 => B,
			Sum   	 => s_addsub_result,
			overflow => s_flow
		);
	beq_comparator: comparator2
		generic map (LENGTH => 8)
		port map (
			input_A	 => A,
			input_B	 => B,
			output_A => open,
			output_Z => s_comp
		);
	
	-- logic below
	process (enable,
	         ALUOp,
	         A,
	         B,
	         s_addsub_result,
	         s_comp,
	         s_flow) is
		variable state : STATE_TYPE;
	begin
		
		if enable = '1' then
			
			state_machine_case: case ALUOp(2 downto 1) is
				when "00"	=> state := load;
				when "01"	=> state := add;
				when "10"	=> state := sub;
				when "11"	=>
					special_state_case: case ALUOp(0) is
						when '0'	=> state := beq;
						when '1'	=> state := print;
						when others	=> state := noop;
					end case special_state_case;
				when others	=> state := noop;
			end case state_machine_case;
			
			logic_case: case state is
				when load =>
					s_op <= '0';
					result <= B;
					-- control signals
					zero <='0';
					oflow <= '0';
					uflow <= '0';
				when add =>
					s_op <= '0';
					result <= s_addsub_result;
					-- control signals
					zero <= '0';
					if s_flow = '1' then
						if A(7) = '0' and B(7) = '0' then
					n		oflow <= '1';
							uflow <= '0';
						elsif A(7) = '1' and B(7) = '1' then
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
				when sub =>
					s_op <= '1';
					result <= s_addsub_result;
					------------------------- Controls -----------------------
					zero <= '0';
					if s_flow = '1' then
						if A(7) = '0' and B(7) = '1' then
							oflow <= '1';
							uflow <= '0';
						elsif A(7) = '1' and B(7) = '0' then
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
					s_op <= '1';
					result <= "XXXXXXXX";
					if s_comp = "00" then
						zero <= '1';
					else
						zero <= '0';
					end if;
					-- control signals
					oflow <= '0';
					uflow <= '0';
				when print =>   -- print
					s_op <= '0';
					result <= "XXXXXXXX";
					print <= A;
					-------------------- Control --------------------
					zero <= '0';
					oflow <= '0';
					uflow <= '0';
				when noop =>   -- noop (do nothing)
					s_op <= '0';
					o_result <= "XXXXXXXX";
					----------------------- Contol ----------------------
					zero <= '0';
					oflow <= '0';
					uflow <= '0';
			end case logic_case;
			
		end if;
	end process;
	
end structural;
