library ieee;
use ieee.std_logic_1164.all;

entity register_file is 
	port(
		-- Control Signals
		CLK	: in std_logic;
		enable	: in  std_logic := '0';
		reset	: in  std_logic := '1';
		regWrite	: in  std_logic := '0';
		
		-- Inputs
		rr1	: in  std_logic_vector (1 downto 0);
		rr2	: in  std_logic_vector (1 downto 0);
		wr	: in  std_logic_vector (1 downto 0);
		wd	: in  std_logic_vector (7 downto 0);
		
		-- Outputs
		rd1	: out std_logic_vector (7 downto 0) := "XXXXXXXX";
		rd2	: out std_logic_vector (7 downto 0) := "XXXXXXXX"
	);
end register_file;

architecture behavior of register_file is

--Index: r0 = 00, r1 = 01, r2 = 10, r3 = 10
	signal r0, r1, r2, r3	 : std_logic_vector (7 downto 0) := "00000000"; 

begin
	process (CLK, enable, reset, regWrite, rr1, rr2, wr, wd) is
	begin
		if rising_edge(reset) then
			r0 <= "00000000";
			r1 <= "00000000";
			r2 <= "00000000";
			r3 <= "00000000";
		elsif enable = '1' then
			if rising_edge(CLK) then
				if rr1 = "00" then
					rd1 <= r0;
				elsif rr1 = "01" then
					rd1 <= r1;
				elsif rr1 = "10" then
					rd1 <= r2;
				elsif rr1 = "11" then
					rd1 <= r3;
				else
					rd1 <= "XXXXXXXX";
				end if;

				if rr2 = "00" then
					rd2 <= r0;
				elsif rr2 = "01" then
					rd2 <= r1;
				elsif rr2 = "10" then
					rd2 <= r2;
				elsif rr2 = "11" then
					rd2 <= r3;
				else
					rd2 <= "XXXXXXXX";
				end if;
			end if;
			
			if regWrite = '1' and (wr'event or wd'event) then
				if wr = "00" then
					r0 <= wd;
				elsif wr = "01" then
					r1 <= wd;
				elsif wr = "10" then
					r2 <= wd;
				elsif wr = "11" then
					r3 <= wd;
				end if;
			end if;
		end if;
	end process;	
end behavior;
