CXX = g++
//CFLAGS = -O2 -Wall -g -pthread
//CXFLAGS = -O4
CFLAGS = -O4

OBJS = main.o Msr.o Cpuid.o Perf.o Rapl.o
CCOBJS = Msr.o Cpuid.o Perf.o Rapl.o
COBJS = cstate.o Msr.o Cpuid.o Perf.o Rapl.o
SOBJS = sleep.o Msr.o Cpuid.o Perf.o Rapl.o
BOBJS = busy.o
INS1OBJS = ins1.o
INS2OBJS = ins2.o
INS3OBJS = ins3.o
INS4OBJS = ins4.o
INS5OBJS = ins5.o
INS6OBJS = ins6.o
INS7OBJS = ins7.o

main:	${OBJS}
	${CXX} ${CFLAGS} -o $@ ${OBJS}

cstate:	${COBJS}
	${CXX} ${CFLAGS} -o $@ ${COBJS}

sleep:	${SOBJS}
	${CXX} ${CFLAGS} -o $@ ${SOBJS}

busy:	${BOBJS} ${CCOBJS}
	${CXX} ${CFLAGS} -o $@ ${BOBJS} ${CCOBJS}

ins1:	${INS1OBJS} ${CCOBJS}
	${CXX} ${CFLAGS} -o $@ ${INS1OBJS} ${CCOBJS}

ins2:	${INS2OBJS} ${CCOBJS}
	${CXX} ${CFLAGS} -o $@ ${INS2OBJS} ${CCOBJS}

ins3:	${INS3OBJS} ${CCOBJS}
	${CXX} ${CFLAGS} -o $@ ${INS3OBJS} ${CCOBJS}

ins4:	${INS4OBJS} ${CCOBJS}
	${CXX} ${CFLAGS} -o $@ ${INS4OBJS} ${CCOBJS}

ins5:	${INS5OBJS} ${CCOBJS}
	${CXX} ${CFLAGS} -o $@ ${INS5OBJS} ${CCOBJS}

ins6:	${INS6OBJS} ${CCOBJS}
	${CXX} ${CFLAGS} -o $@ ${INS6OBJS} ${CCOBJS}

ins7:	${INS7OBJS} ${CCOBJS}
	${CXX} ${CFLAGS} -o $@ ${INS7OBJS} ${CCOBJS}

workALU: workALU.S
	g++ -c -DREPEAT_COUNT=2 -Wa,-adhln -g $< -o $@

jon1:	jon1.o workALU.o ${CCOBJS}
	${CXX} -g jon1.o workALU.o ${CCOBJS} -o $@
#	${CXX} ${CFLAGS} -o $@ jon1.o workALU.o ${CCOBJS}

clean:
	rm -f *.o main cstate sleep ins1 ins2 ins3 ins4

.cc.o:
	${CXX} ${CFLAGS} -c $<




