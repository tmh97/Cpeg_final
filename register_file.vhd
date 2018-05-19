library ieee;
use ieee.std_logic_1164.all;

--------------------------------- Register File -----------------------------
entity register_file is 
	generic (REG_VALUE	 : integer);
	port(
		-- Control Signals
		enable    	 : in  std_logic := '0';
		reset     	 : in  std_logic := '1';
		regWrite  	 : in  std_logic := '0';
		clk       	 : in  std_logic := '0';
		
		-- Inputs
		read_reg1 	 : in  std_logic_vector (1 downto 0);
		read_reg2 	 : in  std_logic_vector (1 downto 0);
		write_reg 	 : in  std_logic_vector (1 downto 0);
		write_data	 : in  std_logic_vector (REG_VALUE-1 downto 0);
		
		-- Outputs
		read_data1	 : out std_logic_vector (REG_VALUE-1 downto 0) := (others => 'X');
		read_data2	 : out std_logic_vector (REG_VALUE-1 downto 0) := (others => 'X')
	);
end register_file;

architecture structural of register_file is

	--------------------------------- Stored Registers----------------------------------------------
	signal reg0	 : std_logic_vector (REG_VALUE-1 downto 0) := (others => '0');	 -- index "00"
	signal reg1	 : std_logic_vector (REG_VALUE-1 downto 0) := (others => '0');	 -- index "01"
	signal reg2	 : std_logic_vector (REG_VALUE-1 downto 0) := (others => '0');	 -- index "10"
	signal reg3	 : std_logic_vector (REG_VALUE-1 downto 0) := (others => '0');	 -- index "11"
	
	
begin
	
	-------------------------------------------- Implementation Logic ---------------------------
	process (enable,
	         reset,
	         clk,
	         regWrite,
	         read_reg1,
	         read_reg2,
	         write_reg,
	         write_data) is
	begin
		if rising_edge(reset) then
			reg0 <= (others => '0'); -- gets set here and remains at this value (whatever it is)
			reg1 <= (others => '0');
			reg2 <= (others => '0');
			reg3 <= (others => '0');
		elsif enable = '1' then
			
			------------------------------------------ Psuedo Read --------------------------------------------------
			if rising_edge(clk) then
				
				-- Read first register
				read_reg1: case read_reg1 i
					when "00"  	 =>	 read_data1 <= reg0;
					when "01"  	 =>	 read_data1 <= reg1;
					when "10"  	 =>	 read_data1 <= reg2;
					when "11"  	 =>	 read_data1 <= reg3;
					when others	 =>	 read_data1 <= (others => 'X');
				end case read_reg1;
				
				-- Read second register
				read_reg2: case read_reg2 is
					when "00"  	 =>	 read_data2 <= reg0;
					when "01"  	 =>	 read_data2 <= reg1;
					when "10"  	 =>	 read_data2 <= reg2;
					when "11"  	 =>	 read_data2 <= reg3;
					when others	 =>	 read_data2 <= (others => 'X');
				end case read_reg2;
				
			end if;
			
			-------------------------------------- Write in Falling and Rising Edge ----------------------------------
			if regWrite = '1' and (write_reg'event or write_data'event) then
			-- if falling_edge(clk) and regWrite = '1' then
				write_reg: case write_reg is
					when "00"  	 =>	 reg0 <= write_data;
					when "01"  	 =>	 reg1 <= write_data;
					when "10"  	 =>	 reg2 <= write_data;
					when "11"  	 =>	 reg3 <= write_data;
					when others	 =>	 null;
				end case write_reg;
			end if;
		end if;
	end process;
	
end structural;
