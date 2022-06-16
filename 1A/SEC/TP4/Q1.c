#include <stdio.h>    /* Input & Output */
#include <stdlib.h>   /* exit */
#include <unistd.h>   /* Basic primitives : fork, read, write, ...*/
#include <fcntl.h>    /* Files operations */
int main (int argc, char** argv) {

    int file_desc;

    if (argc != 2) {
	    printf ("mauvais arguments\n");
	    exit (1);
    }

    file_desc = open (argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0777);


    if (file_desc < 0) {
	    perror ("erreur description\n");
	    exit (1);
    }

    if (dup2 (file_desc, 1) == -1) {
	    perror ("erreur\n");
	    exit (1);
    }

    if (close(file_desc) < 0) {
	    perror("erreur fermeture\n");
	    exit(1);
    }

    if (execlp ("ls", "ls", "--sort=t", NULL) < 0) {
	    perror ("erreur commande ls\n");
	    exit (1);
    }

    return EXIT_SUCCESS ;
}
