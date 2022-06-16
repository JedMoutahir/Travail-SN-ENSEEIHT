#include <stdio.h>    /* Input & Output */
#include <stdlib.h>   /* exit */
#include <unistd.h>   /* Basic primitives : fork, read, write, ...*/
#include <fcntl.h>    /* Files operations */
int main (int argc, char** argv) {

    int p[2];
    int unEntier = 27;

    pid_t pidFils = fork();
    
    if(pidFils == 0){
        close(p[1]);
        int entierLu;
        read(p[0], &entierLu, sizeof(int));
        close(p[0]);
        printf("entier lu : %d\n", entierLu);
    } else {
        pipe(p);
        close(p[0]);
        write(p[1], &unEntier, sizeof(int));
        close(p[1]);
    }

    return EXIT_SUCCESS ;
}
