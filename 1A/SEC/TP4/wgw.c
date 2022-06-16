#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


int main(int argc, char** argv) {

    int i;
    pid_t pidFils;
    pid_t pidFilsFils;
    int pipe1[2];
    int pipe2[2];

    if(argc != 2) {
	    printf("Erreur utilisation : ./wgw username\n");
	    exit(1);
    }

    if(pipe(pipe1) == -1) {
	    perror("Erreur pipe 1\n");
	    exit(1);
    }

    pidFils = fork();

    if(pidFils < 0) {
	    perror("Erreur fork 1\n") ;
	    exit(1);
    }

    else if(pidFils == 0) {
        close(pipe1[0]);

        if(dup2(pipe1[1], 1) == -1) {
            perror("Erreur dup 1 \n");
            exit(1);
        }

        close(pipe1[1]);

    	if(pipe(pipe2) == -1) {
        	perror("Erreur pipe 1\n");
        	exit(1);
    	}

    	pidFilsFils = fork();

    	if(pidFilsFils < 0) {
        	perror("Erreur fork 2\n") ;
        	exit(1);
    	}

	    if(pidFilsFils == 0) {
	        close(pipe2[0]) ;

	        if(dup2(pipe2[1], 1) == -1) {
		        perror("Erreur dup 2 \n");
		        exit(1);
	        }

	        close(pipe2[1]);

	        if(execlp("who", "who", NULL) < 0) {
		        perror("Erreur who\n");
		        exit(1);
	        }
	    }

	    else {
	        close(pipe2[1]) ;

	        if(dup2(pipe2[0], 0) == -1) {
		        perror("Erreur dup 3 \n");
		        exit(1);
	        }

	        close(pipe2[0]);

	        if(execlp("grep", "grep", argv[1], NULL) < 0) {
		        perror("Erreur grep\n");
		        exit(1);
	        }
	    }

	    exit(0);
    }

    else {
	    close(pipe1[1]);

	    if(dup2(pipe1[0], 0) == -1) {
	        perror("Erreur dup 4 \n");
	        exit(1);
	    }

	    close(pipe1[0]);

	    if(execlp("wc", "wc", "-l", NULL) < 0) {
	        perror("Erreur wc\n");
	        exit(1);
	    }
    }

    return EXIT_SUCCESS;
}
