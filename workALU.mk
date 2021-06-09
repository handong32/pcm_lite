# make -f workALU.mk memctest COUNT=3000000
# make -f workALU.mk memtest COUNT=3000000
# make -f workALU.mk workALUtest COUNT=50000000

.PHONEY: clean

workALUtest: main.o workALU.o
	g++ -g main.o workALU.o Msr.o Cpuid.o Perf.o Rapl.o -o $@

memtest: jon2.o workMEM.o
	g++ -g jon2.o workMEM.o Msr.o Cpuid.o Perf.o Rapl.o -o $@

memctest: jon3.o workMEMC.o
	g++ -g jon3.o workMEMC.o Msr.o Cpuid.o Perf.o Rapl.o -o $@

jon2: jon2.cc
	g++ -g -c  $< -o $@

jon3: jon3.cc
	g++ -g -c  $< -o $@

main.o: jon1.cc
	g++ -g -c  $< -o $@

workALU.o: workALU.S
	g++ -c -DREPEAT_COUNT=$(COUNT) -Wa,-adhln -g $< -o $@

workMEM.o: workMEM.S
	g++ -c -DREPEAT_COUNT=$(COUNT) -Wa,-adhln -g $< -o $@

workMEMC.o: workMEMC.S
	g++ -c -DREPEAT_COUNT=$(COUNT) -Wa,-adhln -g $< -o $@

clean:
	-${RM} workALU.o main.o jon2.o workMEM.o workALUtest memtest memctest workMEMC.o jon3.o
