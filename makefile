all:com sim

com:
	vcs -full64 -debug_all ./rtl/dp_ram.v -l com.log


clean:
	rm -rf *.log csrc simv* *.key *.vpd DVEfiles coverage *.vdb verdi* *.out *.conf *.fsdb