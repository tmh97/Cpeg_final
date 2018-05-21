GHDL        = ghdl

#######################################
calculator: add2bit add comparator mux2bit mux extender control_unit register_file alu fetch_to_decode decode_to_execute execute_to_writeback calculator.vhdl calculator_tb.vhdl
	$(GHDL) -a calculator.vhdl  
	$(GHDL) -a calculator_tb.vhdl 
	$(GHDL) -e calculator_tb
#######################################

add: full_adder add.vhdl
	$(GHDL) -a add.vhdl

add2bit: full_adder add2bit.vhdl
	$(GHDL) -a add2bit.vhdl

alu: add comparator alu.vhdl
	$(GHDL) -a alu.vhdl

comparator: comparator.vhdl 
	$(GHDL) -a comparator2.vhdl

control_unit: control_unit.vhdl
	$(GHDL) -a control_unit.vhdl

full_adder: half_adder full_adder.vhd
	$(GHDL) -a full_adder.vhdl 

half_adder: half_adder.vhdl
	$(GHDL) -a half_adder.vhdl

mux: mux.vhdl
	$(GHDL) -a mux.vhdl

mux2bit: mux2bit.vhdl
	$(GHDL) -a mux2bit.vhdl

register_file: register_file.vhdl
	$(GHDL) -a register_file.vhdl

extender: extender.vhdl
	$(GHDL) -a extender.vhdl

fetch_to_decode: fetch_to_decode.vhdl
	$(GHDL) -a fetch_to_decoder.vhdl 

decode_to_execute: decode_to_execute.vhdl
	$(GHDL) -a decode_to_execute.vhdl

execute_to_writeback: $execute_to_writeback.vhdl
	$(GHDL) -a execute_to_writeback.vhdl

clean:
rm -f *.o *.cf *_tb *.out
