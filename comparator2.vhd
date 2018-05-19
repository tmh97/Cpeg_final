library ieee;
use ieee.std_logic_1164.all;

------------------- 2-input Comparator --------------------------------------
entity comparator is
	generic (LENGTH : integer);
	port(
		input_A	 : in  std_logic_vector (LENGTH-1 downto 0);
		input_B	 : in  std_logic_vector (LENGTH-1 downto 0);
		output_A : out std_logic_vector (LENGTH-1 downto 0);
		output_Z: out std_logic_vector (1 downto 0)
	);
end comparator2;

architecture structural of comparator is

	function is_valid(A, B : std_logic_vector) return boolean is
	begin
		-- input_A'range = i_B'range
		for i in input_A'range loop
			if (input_A(i) /= '0' and input_A(i) /= '1')
					or (input_B(i) /= '0' and input_B(i) /= '1') then
				return false;
			end if;
		end loop;
		return true;
	end function;

begin
	
	----------------------------------Logic Implementation------------------------------------------
	process (input_A, input_B) is
	begin
		if is_valid(input_A, input_B) then
			if input_A = input_B then
				output_Z <= "00";
			elsif input_A < input_B then
				outptu_Z <= "10";
			elsif input_A > input_B then
				output_Z <= "01";
			else
				output_Z <= "XX";
			end if;
		else
			output_Z <= "XX";
		end if;
		output_A <= input_A;
	end process;
	
end structural;
