MPICC=smpicc
CFLAGS=-g -O4


DIR=03_overmean
SRC=overmean

all: ${SRC}

%.o: %.c
	echo $@
	$(MPICC) -c -Wall -o $@ $<

${SRC}: ${SRC}.o
	$(MPICC) -o $@ $^

clean:
	rm -rf *.o ${SRC} ${DIR}
