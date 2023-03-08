# Pour compiler la facto symbolique, le minimum degree
#               et Cuthill McKee
#complilation pour Linux + intel compiler
#F90  = LC_ALL=C ifort
#OPT  = -c -g -CB -u
# Compilation sur Mac OS-X
#F90 = gfortran
#OPT = -c  -g

# Compilation avec gfortran
F90 = gfortran
OPT = -c -g -fbounds-check -fimplicit-none
#
TOOLS = definition.o fsmdcm.o 

.SUFFIXES: 
.SUFFIXES: .f90 .mod .o

all: ordering.a validation

ordering.a :  $(TOOLS)
	ar -r $@ $(TOOLS)

validation: validation.o ordering.a
	$(F90) -o $@ validation.o ordering.a

# dependance sur les modules
validation.o : definition.o fsmdcm.o 
fsmdcm.o     : definition.o


.f90.o:
	$(F90) $(OPT) $*.f90

# Nettoyage de la librairie et des objets
clean :
	/bin/rm -f *.o *.a *.mod validation mat_matlab perm_matlabMD

