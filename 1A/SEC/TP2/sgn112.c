#include <stdio.h>    /* entrées/sorties */
#include <unistd.h>   /* primitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <signal.h>

#define MAX_PAUSES 10     /* nombre d'attentes maximum */

void signalHandler(int sig) {
    printf("signal : %d\n", sig);
}

int main(int argc, char *argv[]) {

    struct sigaction theSigaction;
    theSigaction.sa_handler = signalHandler;
	int nbPauses;
	
	nbPauses = 0;
	printf("Processus de pid %d\n", getpid());
	for (int i = 1; i<NSIG; i++){
        sigaction(i, &theSigaction, NULL);
    }
    
	for (nbPauses = 0 ; nbPauses < MAX_PAUSES ; nbPauses++) {
		pause();		// Attente d'un signal
		printf("pid = %d - NbPauses = %d\n", getpid(), nbPauses);
    } ;
    return EXIT_SUCCESS;
}
