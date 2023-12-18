#!/bin/bash
SIMGRID=/mnt/n7fs/ens/tp_guivarch/opt2021/simgrid-3.31

export PATH=${SIMGRID}/bin:${PATH}

alias smpirun="smpirun -hostfile ${SIMGRID}/archis/cluster_hostfile.txt -platform ${SIMGRID}/archis/cluster_crossbar.xml"
