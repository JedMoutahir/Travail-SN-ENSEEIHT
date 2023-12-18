MPICC=smpicc
CFLAGS=-g -O4

DIR=01_RingD
SRC=ringd

all: ${SRC}

%.o: %.c
	echo $@
	$(MPICC) -c -Wall -o $@ $<

${SRC}: ${SRC}.o
	$(MPICC) -o $@ $^

clean:
	rm -rf *.o ${SRC}
