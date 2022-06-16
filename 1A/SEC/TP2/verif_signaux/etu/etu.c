#include <stdio.h>    /* entrées/sorties */
#include <unistd.h>   /* primitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <signal.h>



void handler(int sig) {
    printf("Reception %d\n", sig);
}

int main (int argc, char* argv[]) {
    struct sigaction theSigaction;
    theSigaction.sa_handler = handler;


    sigaction(10, &theSigaction, NULL);
    sigaction(12, &theSigaction, NULL);

//------------Masque les signaux SIGUSR1 et SIGINT------------//
    sigset_t eSignaux;
    sigemptyset(&eSignaux);
    sigaddset(&eSignaux, SIGINT);
    sigaddset(&eSignaux, SIGUSR1);
    sigprocmask(SIG_BLOCK,&eSignaux,NULL);

    sleep(10);

//------------Envoi 2 signaux SIGUSR1------------//
    kill(getpid(), 10);
    kill(getpid(), 10);

    sleep(5);

//------------Envoi 2 signaux SIGUSR2------------//
    kill(getpid(), 12);
    kill(getpid(), 12);

//------------Démasque SIGUSR1------------//
    sigset_t aRetirer;
    sigemptyset(&aRetirer);
    sigaddset(&aRetirer, SIGUSR1);
    sigprocmask(SIG_UNBLOCK,&aRetirer,NULL);
    
    sleep(10);

//------------Démasque SIGUINT------------//
    sigaddset(&aRetirer, SIGINT);
    sigprocmask(SIG_UNBLOCK,&aRetirer, NULL);
    printf("Salut\n");

    return 0;
}
