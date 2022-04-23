# Définition des Variables
CC = c99 
CFLAGS = -Wextra -pedantic -c 
LDFLAGS = -o
EXE = test_file exemple_file

# Règles
all: $(EXE)
test_file: file.o test_file.o
	$(CC) $^ $(LDFLAGS) $@
exemple_file: file.o exemple_file.o 
	$(CC) $^ $(LDFLAGS) $@
makedepend:
	$@ *.c -Y
clean:
	rm $(EXE) *.o
.PHONY: clean all makedepend

