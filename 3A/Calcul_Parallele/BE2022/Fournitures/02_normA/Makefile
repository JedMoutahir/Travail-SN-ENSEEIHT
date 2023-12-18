MPICC=smpicc
CFLAGS=-g -O4

DIR=02_normA
SRC=normA

all: ${SRC}

%.o: %.c
	echo $@
	$(MPICC) -c -Wall -o $@ $<

${SRC}: ${SRC}.o
	$(MPICC) -o $@ $^

clean:
	rm -rf *.o ${SRC} ${DIR}
