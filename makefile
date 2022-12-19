all:com sim

com:
	vcs -full64 -debug_all ./tb/test_dp_ram.v ./rtl/my_dp_ram.v -l com.log
sim:
	./simv -l sim.log
run:
	dve -vpd vcdplus.vpd &

clean:
	rm -rf *.log csrc simv* *.key *.vpd DVEfiles coverage *.vdb verdi* *.out *.conf *.fsdb