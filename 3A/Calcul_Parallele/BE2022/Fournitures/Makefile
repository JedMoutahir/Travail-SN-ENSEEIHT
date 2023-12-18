SOURCES=01_RingD 02_normA 03_overmean 04_n-corps

all: collect


collect:
	echo ${USER}
	(cd 01_RingD; make clean)
	(cd 02_normA; make clean)
	(cd 03_overmean; make clean)
	tar cvf Calcul_${USER}_`hostname | cut -d'.' -f1`.tar ${SOURCES}
