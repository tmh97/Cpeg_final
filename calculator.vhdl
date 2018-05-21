library ieee;
use ieee.std_logic_1164.all;

entity calculator is
	port(
		CLK	: in std_logic;
		reset	: in std_logic;
		enable	: in std_logic;
		instruction_number	: in std_logic_vector(7 downto 0);
		instruction	: in std_logic_vector(7 downto 0);
		pc	: out std_logic_vector(7 downto 0);
		print	: out std_logic_vector(7 downto 0)
	);
end calculator;

architecture behavior of calculator is
	component fetch_to_decode
		port (
			CLK	: in std_logic;
			enable	: in std_logic;
			reset	: in std_logic;
			flush	: in std_logic;
			pc_in	: in std_logic_vector(7 downto 0);
			instruction	: in std_logic_vector(7 downto 0);
			pc_out	: in std_logic_vector (7 downto 0) := "XXXXXXXX";
			output	: in std_logic_vector(7 downto 0) := "XXXXXXXX"
		);
	end component;

	component decode_to_execute
		port (
			CLK	: in std_logic;
			enable	: in std_logic;
			reset	: in std_logic;
			flush	: in std_logic;	
			regDst_in	: in std_logic;
			branch_in	: in std_logic;
			ALUOp_in	: in std_logic_vector(2 downto 0);
			ALUSrc_in	: in std_logic;
			regWrite_in	: in std_logic;
			pc_in	: in std_logic_vector(7 downto 0);
			rd1_in	: in std_logic_vector(7 downto 0);
			rd2_in	: in std_logic_vector(7 downto 0);	
			rs_in	: in std_logic_vector(1 downto 0);
			rd_in	: in std_logic_vector(1 downto 0);
			extended_in : in std_logic_vector(7 downto 0);
			regDst_out	: out std_logic := 'X';
			branch_out	: out std_logic := '0';
			ALUOp_out	: out std_logic_vector(2 downto 0) := "XXXX";
			ALUSrc_out	: out std_logic := 'X';
			regWrite_out	: out std_logic := '0';
			pc_out	: out std_logic_vector(7 downto 0) := "XXXXXXXX";
			rd1_out	: out std_logic_vector(7 downto 0) := "XXXXXXXX";
			rd2_out	: out std_logic_vector(7 downto 0) := "XXXXXXXX";
			rs_out	: out std_logic_vector(1 downto 0) := "XXX";
			rd_out	: out std_logic_vector(1 downto 0) := "XXX",
			extended_out : out std_logic_vector(7 downto 0) := "XXXXXXXX"
		);
	end component;
	
	component execute_to_writeback
		port(
			CLK	: in std_logic;
			enable	: in std_logic;
			reset	: in std_logic;
			flush	: in std_logic;
			branch_in	: in std_logic;
			regWrite_in	: in std_logic;
			pc_in	: in std_logic_vector(7 downto 0);
			wd_in	: in std_logic_vector(7 downto 0);
			wr_in	: in std_logic_vector(1 downto 0);
			skip_in : in std_logic;
			branch_out	: out std_logic;
			regWrite_out	: out std_logic;
			pc_out	: out std_logic_vector(7 downto 0) := "00000000";
			wd_out	: out std_logic_vector(7 downto 0) := "XXXXXXXX";
			wr_out	: out std_logic_vector(1 downto 0) := "XX";
			skip_out : out std_logic := '0'
		);
	end component;

	component add
		port (
			sub	: in std_logic;
			A 	: in std_logic_vector (7 downto 0);
			B	: in std_logic_vector (7 downto 0);
			Sum	: out std_logic_vector (7 downto 0) <= "XXXXXXXX";
			overflow	: out std_logic
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
	
	component mux
		port(
			A	: in std_logic_vector (7 downto 0);
			B	: in std_logic_vector (7 downto 0);
			SEL	: in std_logic;
			O	: in std_logic_vector (7 downto 0)
		);
	end component;

	component alu
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
	end component;

	component register_file
		port(
			CLK	: in std_logic;
			enable	: in  std_logic := '0';
			reset	: in  std_logic := '1';
			regWrite	: in  std_logic := '0';
			rr1	: in  std_logic_vector (1 downto 0);
			rr2	: in  std_logic_vector (1 downto 0);
			wr	: in  std_logic_vector (1 downto 0);
			wd	: in  std_logic_vector (7 downto 0);
			rd1	: out std_logic_vector (7 downto 0) := "XXXXXXXX";
			rd2	: out std_logic_vector (7 downto 0) := "XXXXXXXX"
		);
	end component;

	component extender
		port(
			A   : in  std_logic_vector (3 downto 0);
			O   : out std_logic_vector (7 downto 0)
		);
	end component;

	component add2bit is
		port (
			sub	: in std_logic;
			A 	: in std_logic_vector (1 downto 0);
			B	: in std_logic_vector (1 downto 0);
			Sum	: out std_logic_vector (1 downto 0) <= "XX";
			overflow	: out std_logic
		);
	end component;

	component mux2bit is
		port(
			A	: in std_logic_vector (1 downto 0);
			B	: in std_logic_vector (1 downto 0);
			SEL	: in std_logic;
			O	: in std_logic_vector (1 downto 0)
		);
	end component;

	-- Control signals
	signal enable_signal	 : std_logic := '0';
	signal reset_signal 	 : std_logic := '1';
	signal flush_signal 	 : std_logic := '1';
	
	
	------------------------------------------------------------------------
	-- Instruction Fetch Signals
	------------------------------------------------------------------------
	-- PC signals
	signal num_instructions	: std_logic_vector(7 downto 0) := "XXXXXXXX";
	signal pc_signal	: std_logic_vector(7 downto 0) := "XXXXXXXX";
	signal pc_plus_one	: std_logic_vector(7 downto 0) := "XXXXXXXX";
	------------------------------------------------------------------------
	-- Instruction Decode Signals
	------------------------------------------------------------------------
	-- Control signals
	signal decode_regDst  	 : std_logic;
	signal decode_branch  	 : std_logic;
	signal decode_ALUOp   	 : std_logic_vector(2 downto 0);
	signal decode_ALUSrc  	 : std_logic;
	signal decode_regWrite	 : std_logic;
	-- PC signals
	signal decode_pc	 : std_logic_vector(7 downto 0);
	-- Instruction signals
	signal decode_instruction	 : std_logic_vector(7 downto 0);
	signal decode_control       	 : std_logic_vector(2 downto 0);
	signal decode_rs         	 : std_logic_vector(1 downto 0);
	signal decode_rt            	 : std_logic_vector(1 downto 0);
	signal decode_rd         	 : std_logic_vector(1 downto 0);
	signal decode_imm           	 : std_logic_vector(3 downto 0);
	-- Register file signals
	signal decode_clk     	 : std_logic;
	signal decode_rd1   	 : std_logic_vector(7 downto 0);
	signal decode_rd2   	 : std_logic_vector(7 downto 0);
	signal decode_extended	 : std_logic_vector(7 downto 0);
	
	------------------------------------------------------------------------
	-- Execute Signals
	------------------------------------------------------------------------
	-- Control signals
	signal execute_regDst  	 : std_logic;
	signal execute_branch  	 : std_logic;
	signal execute_ALUOp   	 : std_logic_vector(2 downto 0);
	signal execute_ALUSrc  	 : std_logic;
	signal execute_regWrite	 : std_logic;
	signal execute_skip    	 : std_logic;
	signal execute_overflow      	 : std_logic;
	signal execute_underflow      	 : std_logic;
	-- PC signals
	signal execute_pc           	 : std_logic_vector(7 downto 0);
	signal execute_skip_plus_one             	 : std_logic_vector(1 downto 0);
	signal execute_pc_plus_one_plus_branch	 : std_logic_vector(7 downto 0);
	-- ALU signals
	signal execute_rd1   	 : std_logic_vector(7 downto 0);
	signal execute_rd2   	 : std_logic_vector(7 downto 0);
	signal execute_alu_src         	 : std_logic_vector(7 downto 0);
	signal execute_extended	: std_logic_vector(7 downto 0);
	-- Register file signals
	signal execute_rs        	 : std_logic_vector(1 downto 0);
	signal execute_rd        	 : std_logic_vector(1 downto 0);
	signal execute_wr 	 : std_logic_vector(1 downto 0);
	signal execute_wd	 : std_logic_vector(7 downto 0);
	
	------------------------------------------------------------------------
	-- Writeback Signals
	------------------------------------------------------------------------
	-- Control signals
	signal writeback_branch  	 : std_logic;
	signal writeback_regWrite	 : std_logic;
	signal writeback_skip   	 : std_logic;
	-- PC signals
	signal writeback_pc_plus_one_plus_branch	 : std_logic_vector(7 downto 0);
	signal writeback_mux_sel           	 : std_logic;
	signal writeback_next_buffer          	 : std_logic_vector(7 downto 0);
	signal writeback_pc_next                 	 : std_logic_vector(7 downto 0);
	signal writeback_max_pc                  	 : std_logic_vector(1 downto 0);
	-- Register file signals
	signal writeback_wr 	 : std_logic_vector (1 downto 0);
	signal writeback_wd	 : std_logic_vector (7 downto 0);	
------------------------------------------------------------------------
--                               FETCH                                --
------------------------------------------------------------------------
	max_pc_comparator: comparator
		port map(
			A_in => writeback_next_buffer,
			B => num_instructions,
			A_out => writeback_pc_next,
			O => writeback_max_pc
		);
	
	pc_mux: mux
		port map(
			A => pc_plus_one,
			B => writeback_pc_plus_one_plus_branch,
			SEL => writeback_mux_sel,
			O => writeback_next_buffer
		);

	pc_adder: add
		port map(
			sub => '0',
			A => pc_signal,
			B => "00000001",
			Sum => pc_plus_one,
			overflow => open
		);

	fetch_decode: fetch_to_decode
		port map(
			CLK => CLK,
			enable => enable_signal,
			reset => reset_signal,
			flush => flush_signal,
			pc_in => pc_plus_one,
			instruction => instruction,
			pc_out => decode_pc,
			output => decode_instruction
		);
------------------------------------------------------------------------
--                              DECODE                                --
------------------------------------------------------------------------
	control_unit0 : control_unit
		port map(
			enable => enable_signal,
			instruction => decode_control,
			regDst => decode_regDst,
			branch => decode_branch,
			ALUOp => decode_ALUOp,
			ALUSrc => decode_ALUSrc,
			regWrite => decode_ALUSrc
		);

	regfile: register_file
		port map(
			enable => enable_signal,
			reset => reset_signal,
			regWrite => writeback_regWrite,
			CLK => decode_clk,
			rr1 => decode_rs,
			rr2 => decode_rt,
			wr => writeback_wr,
			wd => writeback_wd,
			rd1 => decode_rd1,
			rd2 => decode_rd2
		);

	extender4_to_8 : extender
		port map(
			 A => decode_imm,
			 O => decode_extended
		)

	decode_exe: decode_to_execute
		port map(
			enable => enable_signal,
			reset => reset_signal,
			flush => flush_signal,
			regDst_in => decode_regDst,
			branch_in => decode_branch,
			ALUOp_in => decode_ALUOp,
			ALUSrc_in => decode_ALUSrc,
			regWrite_in => decode_regWrite,
			pc_in => decode_pc,
			rd1_in => decode_rd1,
			rd2_in => decode_rd2,
			rs_in => decode_rs,
			rd_in => decode_rd,
			extended_in => decode_extended,
			regDst_out => execute_regDst,
			branch_out => execute_branch,
			ALUOp_out => execute_ALUOp,
			ALUSrc_out => execute_ALUSrc,
			regWrite_out => execute_regWrite,
			pc_out => execute_pc,
			rd1_out => execute_rd1,
			rd2_out => execute_rd2,
			rs_out => execute_rs,
			rd_out => execute_rd,
			extended_out => execute_extended
		);
------------------------------------------------------------------------
--                             EXECUTE                                --
------------------------------------------------------------------------	 
	branch_adder: add
		port map(
			sub => '0',
			A => execute_pc,
			B(7 downto 2) => "000000",
			B(1 downto 0) => execute_skip_plus_one,	
			Sum => execute_pc_plus_one_plus_branch,
			overflow => open
		);
	
	skip_adder: add2bit
		port map(
			sub => '0',
			A(1) => '0',
			A(0) => execute_extended(1),
			B => "01",
			Sum => execute_skup_plus_one,
			overflow => open
		);

	alu0 : alu
		port map(
			enable => enable_signal,
			ALUOp => execute_ALUOp,
			A => execute_rd1,
			B => execute_alu_src,
			result => execute_wd,
			print_result => print_output,
			overflow => execute_overflow,
			underflow => execute_underflow,
			skip => execute_skip
		);
	
	alu_src_mux: 
		port map(
			A => execute_rd2,
			B => execute_extended,
			SEL => execute_ALUSrc,
			O => execute_alu_src
		);
	
	dst_reg_mux: mux2bit
		port map(
			A => execute_rs,
			B => execute_rd,
			SEL => ex_regDst,
			O => execute_wr
		);

	exe_wb: execute_to_writeback
		port map(
			CLK => CLK,
			enable => enable_signal,
			reset => reset_signal,
			flush => flush_signal,
			branch_in => execute_branch,
			regWrite_in => execute_regWrite,
			pc_in => execute_pc_plus_1_plus_branch,
			skip_in => execute_skip,
			wd_in => execute_wd,
			wr_in => execute_wr,
			branch_out => writeback_branch,
			regWrite_out => writeback_regWrite,
			pc_out => writeback_pc_plus_1_plus_branch,
			skip_out => writeback_skip,
			wd_out => writeback_wd,
			wr_out => writeback_wr,
		);
	
	writeback_mux_sel <= writeback_branch and writeback_skip;
	
	decode_control <= decode_instruction(7 downto 6) & decode_instruction(0);
	decode_rs <= decode_instruction(5 downto 4);
	decode_rt <= decode_instruction(3 downto 2);
	decode_rd <= decode_instruction(1 downto 0);
	decode_imm <= decode_instruction(3 downto 0);

	process(CLK, enable, reset) is
	begin
		if reset = '1' then
			decode_clk <= '0';
			enable_signal <= '0';
			reset_signal <= '1';
			flush_signal <= '1';
			num_instructions <= instruction_number;
			pc_signal <= "00000000";
		else
			if rising_edge(clk) then
				if enable = '1' then
					if not(writeback_max_pc = "10") then
						enable_signal <= '0';
					else
						enable_signal <= '1';
						reset_signal <= '0';
						if writeback_mux_sel = '1' then
							flush_signal <= '1';
						end if;
						decode_clk <= '1';
						pc_signal <= writeback_pc_next;
					end if;
				else
					enable_signal <= '0';
				end if;
			if falling_edge(clk) then
				decode_clk <= '0';
				flush <= '0';
				if enable_signal ='1' then
				-- print
				end if;
			end if;
		end if;
	end process;

	process(writeback_pc_next, writeback_max_pc) is
	begin
		if enable_signal = '1' and (writeback_max_pc = "10") then
			pc <= writeback_pc_next;
		else
			pc <= "00000000";
		end if;
	end process;
end behavior;
	
end behavior;
